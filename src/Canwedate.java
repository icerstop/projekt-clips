import javax.swing.*; 
import javax.swing.border.*; 
import javax.swing.table.*;
import java.awt.*; 
import java.awt.event.*; 

import java.text.BreakIterator;

import java.util.Locale;
import java.util.ResourceBundle;
import java.util.MissingResourceException;
 
import CLIPSJNI.*;

class Canwedate implements ActionListener {
    JLabel displayLabel;
    String imagePath = "Images/";
    String heartUnselectedPath = imagePath + "heart-unselected.png";
    String heartSelectedPath = imagePath + "heart-selected.png";
    Color mainBackgroundColor = Color.decode("#FFC0CB");
    JButton nextButton;
    JButton prevButton;
    JPanel choicesPanel;
    ButtonGroup choicesButtons;
    ResourceBundle canwedateresources;

    Environment clips;
    boolean isExecuting = false;
    Thread executionThread;

    Canwedate() {
        try {
            canwedateresources = ResourceBundle.getBundle("resources.CanWeDateResources", Locale.getDefault());
        } catch (MissingResourceException mre) {
            mre.printStackTrace();
            return;
        }

       
        JFrame jfrm = new JFrame(canwedateresources.getString("CanWeDate"));
        ImageIcon img = new ImageIcon(imagePath + "heart.png");
        jfrm.setIconImage(img.getImage());

        
        jfrm.getContentPane().setLayout(new GridBagLayout());
        jfrm.getContentPane().setBackground(mainBackgroundColor);

        
        jfrm.setSize(900, 400);

        // Terminate the program on close
        jfrm.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        // Create display panel
        JPanel displayPanel = new JPanel(new GridBagLayout());
        displayLabel = new JLabel();
        displayPanel.add(displayLabel);
        displayPanel.setBackground(mainBackgroundColor);

        // Create choices panel
        choicesPanel = new JPanel(new GridBagLayout());
        choicesButtons = new ButtonGroup();
        choicesPanel.setBackground(mainBackgroundColor);

        // Create button panel
        JPanel buttonPanel = new JPanel(new GridBagLayout());

        prevButton = new JButton(canwedateresources.getString("Prev"));
        prevButton.setActionCommand("Prev");
        prevButton.addActionListener(this);

        nextButton = new JButton(canwedateresources.getString("Next"));
        nextButton.setActionCommand("Next");
        nextButton.addActionListener(this);

        GridBagConstraints gbcButton = new GridBagConstraints();
        gbcButton.gridx = 0;
        gbcButton.gridy = 0;
        gbcButton.insets = new Insets(5, 5, 5, 5);

        buttonPanel.add(prevButton, gbcButton);

        gbcButton.gridx = 1;
        buttonPanel.add(nextButton, gbcButton);
        buttonPanel.setBackground(mainBackgroundColor);

        // Add panels to content pane
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.gridx = 0;
        gbc.gridy = 0;
        gbc.weightx = 1.0;
        gbc.weighty = 1.0;
        gbc.fill = GridBagConstraints.BOTH;
        //gbc.insets = new Insets(10, 10, 10, 10);

        jfrm.getContentPane().add(displayPanel, gbc);

        gbc.gridy = 1;
        jfrm.getContentPane().add(choicesPanel, gbc);

        gbc.gridy = 2;
        jfrm.getContentPane().add(buttonPanel, gbc);

        // Load CLIPS program
        clips = new Environment();

        clips.load("CanWeDate.clp");

        clips.reset();
        runAuto();

        // Display the frame
        jfrm.setVisible(true);
    }

    private void nextUIState() throws Exception {
        /*=====================*/
        /* Get the state-list. */
        /*=====================*/
        String evalStr = "(find-all-facts ((?f state-list)) TRUE)";

        String currentID = clips.eval(evalStr).get(0).getFactSlot("current").toString();

        /*===========================*/
        /* Get the current UI state. */
        /*===========================*/

        evalStr = "(find-all-facts ((?f UI-state)) " +
                  "(eq ?f:id " + currentID + "))";

        PrimitiveValue fv = clips.eval(evalStr).get(0);

        /*========================================*/
        /* Determine the Next/Prev button states. */
        /*========================================*/

        if (fv.getFactSlot("state").toString().equals("final")) {
            nextButton.setActionCommand("Restart");
            nextButton.setText(canwedateresources.getString("Restart"));
            prevButton.setVisible(true);
        } else if (fv.getFactSlot("state").toString().equals("initial")) {
            nextButton.setActionCommand("Next");
            nextButton.setText(canwedateresources.getString("Next"));
            prevButton.setVisible(false);
        } else {
            nextButton.setActionCommand("Next");
            nextButton.setText(canwedateresources.getString("Next"));
            prevButton.setVisible(true);
        }

        /*=====================*/
        /* Set up the choices. */
        /*=====================*/

        choicesPanel.removeAll(); // Remove all previous components
        choicesPanel.setLayout(new GridBagLayout()); // Reset layout to default
        choicesButtons = new ButtonGroup();

        if (fv.getFactSlot("state").toString().equals("final")) {
            String path = imagePath + fv.getFactSlot("display").toString() + ".png";
            ImageIcon originalIcon = new ImageIcon(path);

            JLabel imageLabel = new JLabel(originalIcon);
            choicesPanel.add(imageLabel, new GridBagConstraints()); // Center the image
        } else {
            PrimitiveValue pv = fv.getFactSlot("valid-answers");
            String selected = fv.getFactSlot("response").toString();


            for (int i = 0; i < pv.size(); i++) {
                PrimitiveValue bv = pv.get(i);
                JRadioButton rButton;

                if (bv.toString().equals(selected)) {
                    rButton = new CustomJRadioButton(heartUnselectedPath, heartSelectedPath, canwedateresources.getString(bv.toString()), true);
                } else {
                    rButton = new CustomJRadioButton(heartUnselectedPath, heartSelectedPath, canwedateresources.getString(bv.toString()), false);
                }

                rButton.setActionCommand(bv.toString());
                choicesPanel.add(rButton);
                choicesButtons.add(rButton);
            }
        }

        choicesPanel.revalidate();
        choicesPanel.repaint();

        /*====================================*/
        /* Set the label to the display text. */
        /*====================================*/

        String theText = canwedateresources.getString(fv.getFactSlot("display").symbolValue());

        wrapLabelText(displayLabel, theText);

        executionThread = null;

        isExecuting = false;
    }
    public void actionPerformed(ActionEvent ae) {
        try {
            onActionPerformed(ae);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void runAuto() {
        Runnable runThread = new Runnable() {
            public void run() {
                clips.run();

                SwingUtilities.invokeLater(new Runnable() {
                    public void run() {
                        try {
                            nextUIState();
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                });
            }
        };

        isExecuting = true;

        executionThread = new Thread(runThread);

        executionThread.start();
    }

    public void onActionPerformed(ActionEvent ae) throws Exception {
        if (isExecuting) return;

        String evalStr = "(find-all-facts ((?f state-list)) TRUE)";

        String currentID = clips.eval(evalStr).get(0).getFactSlot("current").toString();

        if (ae.getActionCommand().equals("Next")) {
            if (choicesButtons.getButtonCount() == 0) {
                clips.assertString("(next " + currentID + ")");
            } else {
                clips.assertString("(next " + currentID + " " + choicesButtons.getSelection().getActionCommand() + ")");
            }

            runAuto();
        } else if (ae.getActionCommand().equals("Restart")) {
            clips.reset();
            runAuto();
        } else if (ae.getActionCommand().equals("Prev")) {
            clips.assertString("(prev " + currentID + ")");
            runAuto();
        }
    }

    private void wrapLabelText(JLabel label, String text) {
        FontMetrics fm = label.getFontMetrics(label.getFont());
        Container container = label.getParent();
        int containerWidth = container.getWidth();
        int textWidth = SwingUtilities.computeStringWidth(fm, text);
        int desiredWidth;

        if (textWidth <= containerWidth) {
            desiredWidth = containerWidth;
        } else {
            int lines = (int) ((textWidth + containerWidth) / containerWidth);

            desiredWidth = (int) (textWidth / lines);
        }

        BreakIterator boundary = BreakIterator.getWordInstance();
        boundary.setText(text);

        StringBuffer trial = new StringBuffer();
        StringBuffer real = new StringBuffer("<html><center>");

        int start = boundary.first();
        for (int end = boundary.next(); end != BreakIterator.DONE; start = end, end = boundary.next()) {
            String word = text.substring(start, end);
            trial.append(word);
            int trialWidth = SwingUtilities.computeStringWidth(fm, trial.toString());
            if (trialWidth > containerWidth) {
                trial = new StringBuffer(word);
                real.append("<br>");
                real.append(word);
            } else if (trialWidth > desiredWidth) {
                trial = new StringBuffer("");
                real.append(word);
                real.append("<br>");
            } else {
                real.append(word);
            }
        }

        real.append("</html>");

        label.setText(real.toString());
    }

    public static void main(String args[]) {
        SwingUtilities.invokeLater(new Runnable() {
            public void run() {
                new Canwedate();
            }
        });
    }
}

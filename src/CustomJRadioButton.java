import javax.swing.*;
import java.awt.*;

public class CustomJRadioButton extends JRadioButton {
	
	public CustomJRadioButton(String unselectedIconPath, String selectedIconPath, String text, boolean isSelected) {
        super(text, isSelected); // Wywołanie konstruktora JRadioButton

        setIcon(loadScaledIcon(unselectedIconPath, 16, 16));
        setSelectedIcon(loadScaledIcon(selectedIconPath, 16, 16)); 

        
        setContentAreaFilled(false);
        setBorderPainted(false);
        setFocusPainted(false);
    }

   
    private ImageIcon loadScaledIcon(String path, int width, int height) {
        ImageIcon originalIcon = new ImageIcon(path);
        Image scaledImage = originalIcon.getImage().getScaledInstance(width, height, Image.SCALE_SMOOTH);
        return new ImageIcon(scaledImage);
    }

}

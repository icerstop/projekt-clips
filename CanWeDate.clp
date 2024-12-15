(deftemplate UI-state
   (slot id (default-dynamic (gensym*)))
   (slot display)
   (slot relation-asserted (default none))
   (slot response (default none))
   (multislot valid-answers)
   (slot state (default middle)))
   
(deftemplate state-list
   (slot current)
   (multislot sequence))
  
(deffacts startup
   (state-list))

(defrule system-banner ""
  =>
  (assert (UI-state (display WelcomeMessage)
                    (relation-asserted start)
                    (state initial)
                    (valid-answers))))

; questions

(defrule relationship-type ""
   (logical (start))
   =>
   (assert (UI-state (display RelationshipQuestion)
                     (relation-asserted relationship)
                     (response Professional)
                     (valid-answers Professional Personal Other))))

(defrule professional-relation ""
   (logical (relationship Professional))
   =>
   (assert (UI-state (display ProfessionalSubtypeQuestion)
                     (relation-asserted professional-subtype)
                     (response Costar)
                     (valid-answers Costar Stalker Therapist SocialWorker Landlord Physician BossCoworker Professor Teacher Student))))

(defrule its-my-costar ""
   (logical (professional-subtype Costar))
   =>
   (assert (UI-state (display CostarQuestion)
                     (relation-asserted dispel-rumors)
                     (response No)
                     (valid-answers No Yes))))

(defrule its-my-stalker ""
   (logical (professional-subtype Stalker))
   =>
   (assert (UI-state (display StalkerQuestion)
                     (relation-asserted restraining-order)
                     (response No)
                     (valid-answers No Yes))))

(defrule gonna-realize ""
   (logical (restraining-order Yes))
   =>
   (assert (UI-state (display GonnaRealizeQuestion)
                     (relation-asserted gonna-love)
                     (response Never )
                     (valid-answers Never Today))))

(defrule its-my-therapist ""
   (logical (professional-subtype Therapist))
   =>
   (assert (UI-state (display AreYouCrazyProQuestion)
                     (relation-asserted crazy-pro)
                     (response DontThink)
                     (valid-answers DontThink MaybeLittle))))
                     
(defrule its-my-socialworker ""
   (logical (professional-subtype SocialWorker))
   =>
   (assert (UI-state (display SocialWorkerQuestion)
                     (relation-asserted kids-back)
                     (response No)
                     (valid-answers No Yes))))

(defrule its-my-landlord ""
   (logical (professional-subtype Landlord))
   =>
   (assert (UI-state (display LandlordQuestion)
                     (relation-asserted ny-sf-live)
                     (response No)
                     (valid-answers No Yes))))

(defrule its-my-physician ""
   (logical (professional-subtype Physician))
   =>
   (assert (UI-state (display HealthRiskQuestion)
                     (relation-asserted health-risk)
                     (response No)
                     (valid-answers No Yes))))

(defrule does-job-suck ""
   (or
   (logical (professional-subtype BossCoworker))
   (logical (where-teach College))
   )
   =>
   (assert (UI-state (display JobSuckQuestion)
                     (relation-asserted job-suck)
                     (response No)
                     (valid-answers No Yes))))

(defrule its-my-student ""
   (or
   (logical (professional-subtype Student))
   )
   =>
   (assert (UI-state (display StudentQuestion)
                     (relation-asserted where-teach)
                     (response College)
                     (valid-answers College BelowCollege))))

(defrule talking-minor-sex ""
   (logical (where-teach BelowCollege))
   =>
   (assert (UI-state (display MinorSexQuestion)
                     (relation-asserted minor-sex)
                     (response OfCourseNot)
                     (valid-answers OfCourseNot Yeah))))

(defrule personal-subtype ""
   (logical (relationship Personal))
   =>
   (assert (UI-state (display RelatedQuestion)
                     (relation-asserted related)
                     (response No)
                     (valid-answers No Yes))))

(defrule no-related ""
   (logical (related No))
   =>
   (assert (UI-state (display NoRelatedQuestion)
                     (relation-asserted no-related-subtype)
                     (response MissedConnection)
                     (valid-answers MissedConnection BFSibling Dealer Roommate Soulmate Cellmate Dungeon Crush))))

(defrule lonely ""
   (logical (no-related-subtype MissedConnection))
   =>
   (assert (UI-state (display LonelyQuestion)
                     (relation-asserted how-lonely)
                     (response ALittle)
                     (valid-answers ALittle NotAtAll))))

(defrule crazy ""
   (logical (no-related-subtype BFSibling))
   =>
   (assert (UI-state (display AreYouCrazyPersQuestion)
                     (relation-asserted crazy-pers)
                     (response DontThink)
                     (valid-answers DontThink ALittle))))

(defrule high ""
   (logical (no-related-subtype Dealer))
   =>
   (assert (UI-state (display GetHighQuestion)
                     (relation-asserted get-high)
                     (response No)
                     (valid-answers No Yes))))

(defrule drama ""
   (logical (no-related-subtype Roommate))
   =>
   (assert (UI-state (display DramaQuestion)
                     (relation-asserted like-drama)
                     (response No)
                     (valid-answers No Yes))))

(defrule are-you-done ""
   (logical (no-related-subtype Soulmate))
   =>
   (assert (UI-state (display HavingSexQuestion)
                     (relation-asserted having-sex)
                     (response No)
                     (valid-answers No Yes))))

(defrule choice-matter ""
   (logical (no-related-subtype Cellmate))
   =>
   (assert (UI-state (display ChoiceQuestion)
                     (relation-asserted choice)
                     (response No)
                     (valid-answers No Yes))))

(defrule yes-related ""
   (logical (related Yes))
   =>
   (assert (UI-state (display BloodQuestion)
                     (relation-asserted blood)
                     (response No)
                     (valid-answers No Yes))))

(defrule no-blood ""
   (logical (blood No))
   =>
   (assert (UI-state (display BloodNoQuestion)
                     (relation-asserted related-no-blood)
                     (response NoBlood1)
                     (valid-answers NoBlood1 NoBlood2))))

(defrule parents ""
   (logical (related-no-blood NoBlood2))
   =>
   (assert (UI-state (display ParentsQuestion)
                     (relation-asserted still-married)
                     (response No)
                     (valid-answers No Yes))))

(defrule allen ""
   (logical (still-married Yes))
   =>
   (assert (UI-state (display WoodyAllenQuestion)
                     (relation-asserted woody-allen)
                     (response No)
                     (valid-answers No Yes))))

(defrule childhood ""
   (logical (still-married No))
   =>
   (assert (UI-state (display GrowQuestion)
                     (relation-asserted together)
                     (response No)
                     (valid-answers No Yes))))

(defrule yes-blood ""
   (logical (blood Yes))
   =>
   (assert (UI-state (display BloodYesQuestion)
                     (relation-asserted related-yes-blood)
                     (response Blood1)
                     (valid-answers Blood1 Blood2))))

(defrule love-or-desperate ""
   (logical (related-yes-blood Blood2))
   =>
   (assert (UI-state (display LoveDesperateQuestion)
                     (relation-asserted love-desperate)
                     (response Desperate)
                     (valid-answers Desperate ReallyLove))))

(defrule where-live ""
   (logical (love-desperate ReallyLove))
   =>
   (assert (UI-state (display AreaQuestion)
                     (relation-asserted live-there)
                     (response No)
                     (valid-answers No Yes))))

(defrule other-subtype ""
   (logical (relationship Other))
   =>
   (assert (UI-state (display OtherSubtypeQuestion)
                     (relation-asserted other-subtype)
                     (response Ghost)
                     (valid-answers Ghost BFEx Xbox Animal Lovebot))))

(defrule like-moore-swayze ""
   (logical (other-subtype Ghost))
   =>
   (assert (UI-state (display MooreSwayzeQuestion)
                     (relation-asserted moore-swayze)
                     (response ExactlyLike)
                     (valid-answers ExactlyLike ReallyNothing))))

(defrule among-living ""
   (logical (moore-swayze ReallyNothing))
   =>
   (assert (UI-state (display WouldYouQuestion)
                     (relation-asserted would-you)
                     (response No)
                     (valid-answers No Yes))))

(defrule best-friends-ex ""
   (logical (other-subtype BFEx))
   =>
   (assert (UI-state (display StoppedQuestion)
                     (relation-asserted how-long)
                     (response ItsBeenAwhile)
                     (valid-answers ItsBeenAwhile TechnicallyTheyHavent))))

(defrule still-friends ""
   (logical (how-long ItsBeenAwhile))
   =>
   (assert (UI-state (display FriendsQuestion)
                     (relation-asserted friends-enemies)
                     (response FriendlyEnough)
                     (valid-answers FriendlyEnough TheyHaveSworn))))

(defrule age ""
   (logical (other-subtype Xbox))
   =>
   (assert (UI-state (display HowOldQuestion)
                     (relation-asserted how-old)
                     (response Over18)
                     (valid-answers Over18 Under18))))

(defrule alone ""
   (logical (how-old Over18))
   =>
   (assert (UI-state (display AloneQuestion)
                     (relation-asserted be-alone)
                     (response No)
                     (valid-answers No Yes))))

(defrule date-animal ""
   (logical (other-subtype Animal))
   =>
   (assert (UI-state (display AnimalQuestion)
                     (relation-asserted date-animal)
                     (response No)
                     (valid-answers No Yes))))

(defrule you-farmer ""
   (logical (date-animal Yes))
   =>
   (assert (UI-state (display FarmerQuestion)
                     (relation-asserted farmer)
                     (response No)
                     (valid-answers No Yes))))

(defrule my-lovebot ""
   (logical (other-subtype Lovebot))
   =>
   (assert (UI-state (display JapanQuestion)
                     (relation-asserted japan-live)
                     (response No)
                     (valid-answers No Yes))))

(defrule will-you-move ""
   (logical (japan-live No))
   =>
   (assert (UI-state (display MoveQuestion)
                     (relation-asserted please-move)
                     (response No)
                     (valid-answers No Yes))))

(defrule per-se ""
   (logical (date-animal No))
   =>
   (assert (UI-state (display NotDateQuestion)
                     (relation-asserted not-per-se)
                     (response But)
                     (valid-answers But Hmm))))

; answers





(defrule respond-sex-tape ""
   (logical (dispel-rumors No))
   =>
   (assert (UI-state (display SexTapeRespond)
                     (state final))))                  

(defrule respond-pattinson ""
   (logical (dispel-rumors Yes))
   =>
   (assert (UI-state (display PattinsonRespond)
                     (state final))))

(defrule respond-better-not ""
   (or
   (logical (restraining-order No))
   (logical (gonna-love Never))
   (logical (crazy-pro MaybeLittle))
   (logical (ny-sf-live No))
   (logical (health-risk Yes))
   (logical (get-high No))
   (logical (like-drama No))
   (logical (having-sex No))
   (logical (choice Yes))
   (logical (would-you No))
   (logical (job-suck No))
   )
   =>
   (assert (UI-state (display BetterNotRespond)
                     (state final))))

(defrule respond-hands ""
   (or
   (logical (gonna-love Today))
   (logical (crazy-pro DontThink))
   (logical (health-risk No))
   )
   =>
   (assert (UI-state (display HandsRespond)
                     (state final))))

(defrule respond-do-whatever ""
   (or
   (logical (kids-back Yes))
   (logical (ny-sf-live Yes))
   )
   =>
   (assert (UI-state (display DoWhateverRespond)
                     (state final))))

(defrule respond-bone ""
   (or
   (logical (professional-subtype Professor))
   (logical (job-suck Yes))
   )
   =>
   (assert (UI-state (display BoneRespond)
                     (state final))))

(defrule respond-thought-crime ""
   (or
   (logical (minor-sex Yeah))
   (logical (minor-sex OfCourseNot))
   )
   =>
   (assert (UI-state (display ThoughtCrimeRespond)
                     (state final))))

(defrule respond-absolutely-not ""
   (or
   (logical (professional-subtype Teacher))
   (logical (together Yes))
   (logical (related-yes-blood Blood1))
   (logical (woody-allen No))
   (logical (how-long TechnicallyTheyHavent))
   (logical (friends-enemies TheyHaveSworn))
   (logical (not-per-se But))
   (logical (not-per-se Hmm))
   (logical (farmer No))
   (logical (please-move No))
   )
   =>
   (assert (UI-state (display AbsolutelyNotRespond)
                     (state final))))

(defrule respond-bad-liar ""
   (or
   (logical (how-lonely NotAtAll))
   (logical (crazy-pers DontThink))
   )
   =>
   (assert (UI-state (display BadLiarRespond)
                     (state final))))

(defrule respond-screw ""
   (or
   (logical (how-lonely ALittle))
   (logical (crazy-pers ALittle))
   (logical (get-high Yes))
   )
   =>
   (assert (UI-state (display ScrewRespond)
                     (state final))))

(defrule respond-awesome ""
   (logical (like-drama Yes))
   =>
   (assert (UI-state (display AwesomeRespond)
                     (state final))))

(defrule respond-obvious ""
   (or
   (logical (having-sex Yes))
   (logical (choice No))
   )
   =>
   (assert (UI-state (display PrettyObviousRespond)
                     (state final))))

(defrule respond-dungeon ""
   (logical (no-related-subtype Dungeon))
   =>
   (assert (UI-state (display DungeonRespond)
                     (state final))))

(defrule respond-crush ""
   (logical (no-related-subtype Crush))
   =>
   (assert (UI-state (display CrushRespond)
                     (state final)))) 

(defrule respond-captain ""
   (or
   (logical (related-no-blood NoBlood1))
   (logical (woody-allen Yes))
   )
   =>
   (assert (UI-state (display CaptainRespond)
                     (state final))))

(defrule respond-hang-in ""
   (or
   (logical (love-desperate Desperate))
   (logical (live-there No))
   )
   =>
   (assert (UI-state (display HangInRespond)
                     (state final))))

(defrule respond-downlow ""
   (or
   (logical (live-there Yes))
   (logical (farmer Yes))
   (logical (japan-live Yes))
   (logical (please-move Yes))
   )
   =>
   (assert (UI-state (display DownlowRespond)
                     (state final))))

(defrule respond-ghost ""
   (or
   (logical (moore-swayze ExactlyLike))
   (logical (would-you Yes))
   )
   =>
   (assert (UI-state (display GhostRespond)
                     (state final))))

(defrule respond-clear-it ""
   (logical (friends-enemies FriendlyEnough))
   =>
   (assert (UI-state (display ClearItRespond)
                     (state final))))

(defrule respond-game-on ""
   (or
   (logical (how-old Under18))
   (logical (be-alone Yes))
   )
   =>
   (assert (UI-state (display TheBestRespond)
                     (state final))))

(defrule respond-controller ""
   (logical (be-alone No))
   =>
   (assert (UI-state (display ControllerRespond)
                     (state final))))


; GUI Interaction Rules

(defrule ask-question

   (declare (salience 5))
   
   (UI-state (id ?id))
   
   ?f <- (state-list (sequence $?s&:(not (member$ ?id ?s))))
             
   =>
   
   (modify ?f (current ?id)
              (sequence ?id ?s))
   
   (halt))

(defrule handle-next-no-change-none-middle-of-chain

   (declare (salience 10))
   
   ?f1 <- (next ?id)

   ?f2 <- (state-list (current ?id) (sequence $? ?nid ?id $?))
                      
   =>
      
   (retract ?f1)
   
   (modify ?f2 (current ?nid))
   
   (halt))

(defrule handle-next-response-none-end-of-chain

   (declare (salience 10))
   
   ?f <- (next ?id)

   (state-list (sequence ?id $?))
   
   (UI-state (id ?id)
             (relation-asserted ?relation))
                   
   =>
      
   (retract ?f)

   (assert (add-response ?id)))   

(defrule handle-next-no-change-middle-of-chain

   (declare (salience 10))
   
   ?f1 <- (next ?id ?response)

   ?f2 <- (state-list (current ?id) (sequence $? ?nid ?id $?))
     
   (UI-state (id ?id) (response ?response))
   
   =>
      
   (retract ?f1)
   
   (modify ?f2 (current ?nid))
   
   (halt))

(defrule handle-next-change-middle-of-chain

   (declare (salience 10))
   
   (next ?id ?response)

   ?f1 <- (state-list (current ?id) (sequence ?nid $?b ?id $?e))
     
   (UI-state (id ?id) (response ~?response))
   
   ?f2 <- (UI-state (id ?nid))
   
   =>
         
   (modify ?f1 (sequence ?b ?id ?e))
   
   (retract ?f2))
   
(defrule handle-next-response-end-of-chain

   (declare (salience 10))
   
   ?f1 <- (next ?id ?response)
   
   (state-list (sequence ?id $?))
   
   ?f2 <- (UI-state (id ?id)
                    (response ?expected)
                    (relation-asserted ?relation))
                
   =>
      
   (retract ?f1)

   (if (neq ?response ?expected)
      then
      (modify ?f2 (response ?response)))
      
   (assert (add-response ?id ?response)))   

(defrule handle-add-response

   (declare (salience 10))
   
   (logical (UI-state (id ?id)
                      (relation-asserted ?relation)))
   
   ?f1 <- (add-response ?id ?response)
                
   =>
      
   (str-assert (str-cat "(" ?relation " " ?response ")"))
   
   (retract ?f1))   

(defrule handle-add-response-none

   (declare (salience 10))
   
   (logical (UI-state (id ?id)
                      (relation-asserted ?relation)))
   
   ?f1 <- (add-response ?id)
                
   =>
      
   (str-assert (str-cat "(" ?relation ")"))
   
   (retract ?f1))   

(defrule handle-prev

   (declare (salience 10))
      
   ?f1 <- (prev ?id)
   
   ?f2 <- (state-list (sequence $?b ?id ?p $?e))
                
   =>
   
   (retract ?f1)
   
   (modify ?f2 (current ?p))
   
   (halt))
   
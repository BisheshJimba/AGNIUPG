pageextension 50519 pageextension50519 extends "Resource Card"
{
    // 10.10.2016 EB.P7 #WSH16
    //   25006292"On Task Start"
    // 
    // 17.10.2013 EDMS P8
    //   * Added fields 'Allow Simultaneous Work'
    // 
    // 28.09.2011 EDMS P1
    //   * Skill action changed to open EDMS skills instead of standard service skills
    layout
    {

        //Unsupported feature: Property Modification (SubPageLink) on "Control 1906609707".

        addafter("Control 20")
        {
            field("Serv. Schedule Password"; "Serv. Schedule Password")
            {
                ExtendedDatatype = Masked;
            }
            field("Service Work Group Code"; "Service Work Group Code")
            {
            }
        }
        addafter("Control 7")
        {
            field("Allow Simultaneous Work"; "Allow Simultaneous Work")
            {
            }
            field("On Task Start"; "On Task Start")
            {
            }
            field("Is Bay"; "Is Bay")
            {
            }
            field("Resource Type"; "Resource Type")
            {
            }
            field("M Skill"; "M Skill")
            {
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 58".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 84".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 70".


        //Unsupported feature: Property Modification (RunObject) on "Action 36".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 36".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 59".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 61".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 62".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 66".


        //Unsupported feature: Property Modification (RunPageView) on "Action 60".

        addafter("Action 66")
        {
            action("Schedule Resource Links")
            {
                Caption = 'Schedule Resource Links';
                Image = Link;
                RunObject = Page 25006298;
            }
        }
    }
}


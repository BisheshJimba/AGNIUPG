pageextension 50576 pageextension50576 extends "Profile List"
{
    layout
    {
        addafter("Control 1102601000")
        {
            field("Company Name"; "Company Name")
            {
            }
        }
    }
    actions
    {
        addafter(SetDefaultRoleCenter)
        {
            action("<Action1101904000>")
            {
                Caption = 'Setup';
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    UserProfileMgt: Codeunit "25006002";
                    UserProfileSetup: Record "25006067";
                begin
                    //EDMS
                    UserProfileMgt.InitUserProfileSetup(Rec);
                    UserProfileSetup.SETRANGE("Profile ID", Rec."Profile ID");
                    PAGE.RUNMODAL(PAGE::"User Profile Setup", UserProfileSetup);
                end;
            }
        }
    }


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CanRunDotNetOnClient := FileManagement.CanRunDotNetOnClient
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    CanRunDotNetOnClient := FileManagement.CanRunDotNetOnClient;
    FilterProfile;  //AGNI2017CU8
    */
    //end;
}


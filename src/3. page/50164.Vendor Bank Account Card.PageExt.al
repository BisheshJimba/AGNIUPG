pageextension 50164 pageextension50164 extends "Vendor Bank Account Card"
{

    //Unsupported feature: Property Insertion (Name) on ""Vendor Bank Account Card"(Page 425)".

    Editable = false;

    //Unsupported feature: Property Insertion (Name) on ""Vendor Bank Account Card"(Page 425)".

    Editable = false;
    layout
    {
        addafter("Control 1")
        {
            group("NCHL-NPI Integration")
            {
                field("Bank ID"; "Bank ID")
                {
                }
                field("Bank Name"; "Bank Name")
                {
                    Editable = true;
                }
                field("Bank Branch No."; Rec."Bank Branch No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the bank branch.';
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number used by the bank for the bank account.';
                }
                field("Bank Branch Name"; "Bank Branch Name")
                {
                }
            }
        }
    }
    actions
    {

        addfirst(navigation)
        {
            group()
            {
                action("Test Bank Account Validation")
                {
                    Image = TestFile;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = TestAccVisible;
                }
            }
        }
    }

    var
        "--NCHL-NPI_1.00--": Integer;
        CompanyInfo: Record "79";
        TestAccVisible: Boolean;


    //Unsupported feature: Code Insertion on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //begin
    /*
    SetControlAppearance; //NCHL-NPI_1.00
    */
    //end;

    local procedure SetControlAppearance()
    begin
        CompanyInfo.GET;
        TestAccVisible := CompanyInfo."Enable NCHL-NPI Integration";
    end;
}


pageextension 50165 pageextension50165 extends "Vendor Bank Account List"
{
    layout
    {
        addfirst("Control 1")
        {
            field("Vendor No."; Rec."Vendor No.")
            {
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


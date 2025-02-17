pageextension 50022 pageextension50022 extends "G/L Registers"
{

    //Unsupported feature: Property Modification (SourceTableView) on ""G/L Registers"(Page 116)".

    layout
    {
        addafter("Control 29")
        {
            field("From TDS Entry No."; Rec."From TDS Entry No.")
            {
            }
            field("To TDS Entry No."; Rec."To TDS Entry No.")
            {
            }
            field(BranchCode; BranchCode)
            {
                Caption = 'Branch Code';
            }
            field(CostRev; CostRev)
            {
                Caption = 'Cost Revenue Code';
            }
            field("Pre Assigned No."; Rec."Pre Assigned No.")
            {
            }
        }
    }
    actions
    {


        //Unsupported feature: Code Modification on "ReverseRegister(Action 32).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        TESTFIELD("No.");
        ReversalEntry.ReverseRegister("No.");
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        UserSetup.GET(USERID);
        IF NOT UserSetup."Can Reverse Journel" THEN
          ERROR('you do not have Permission to Reverse');
        TESTFIELD("No.");
        ReversalEntry.ReverseRegister("No.");
        */
        //end;
    }

    var
        BranchCode: Code[20];
        CostRev: Code[20];
        GLEntry: Record "17";
        UserSetup: Record "91";


    //Unsupported feature: Code Insertion on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //begin
    /*

    BranchCode := '';
    CostRev := '';
    GLEntry.RESET;
    GLEntry.SETRANGE("Entry No.","From Entry No.");
    IF GLEntry.FINDFIRST THEN BEGIN
      BranchCode := GLEntry."Global Dimension 1 Code";
      CostRev := GLEntry."Global Dimension 2 Code";
    END;
    */
    //end;
}


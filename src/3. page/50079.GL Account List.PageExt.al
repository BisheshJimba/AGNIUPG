pageextension 50079 pageextension50079 extends "G/L Account List"
{
    layout
    {

        //Unsupported feature: Property Modification (SubPageLink) on "Control 1905532107".

    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageView) on "Action 23".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 20".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 84".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 132".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 32".

    }
    var
        [InDataSet]
        "No.Emphasize": Boolean;
        [InDataSet]
        BoldValue: Boolean;
        [InDataSet]
        NameEmphasize: Boolean;


    //Unsupported feature: Code Modification on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    NameIndent := 0;
    FormatLine;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    NameIndent := 0;
    FormatLine;

    //To show bold lines if condition is true. Sangam on 25 August 2011.
    BoldLine("Account Type");
    */
    //end;

    local procedure NoOnFormat()
    begin
        "No.Emphasize" := Rec."Account Type" <> Rec."Account Type"::Posting;
    end;

    local procedure NameOnFormat()
    begin
        NameIndent := Rec.Indentation;
        NameEmphasize := Rec."Account Type" <> Rec."Account Type"::Posting;
    end;

    procedure BoldLine(AccountType: Option Posting,Heading,Total,"Begin-Total","End-Total")
    begin
        //To show bold lines if condition is true.
        IF (AccountType = AccountType::Heading) OR (AccountType = AccountType::Total) OR (AccountType = AccountType::"Begin-Total")
          OR (AccountType = AccountType::"End-Total") THEN
            BoldValue := TRUE
        ELSE
            BoldValue := FALSE;
    end;
}


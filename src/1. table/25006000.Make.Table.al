table 25006000 Make
{
    // 25.02.2015 EDMS P21
    //   Added field:
    //     30 Picture
    // 
    // 10.05.2008. EDMS P2
    //   * Added code OnDelete
    // 
    // 13.08.2007. EDMS P2
    //   * Added field "Veh. Evaluation View Code"
    // 
    // 08.11.2004 EDMS P1
    //   *Changed property DrillDownForm

    Caption = 'Make';
    DataPerCompany = false;
    DrillDownPageID = "Make List";
    LookupPageID = "Make List";

    fields
    {
        field(10; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(20; Name; Text[30])
        {
            Caption = 'Name';
        }
        field(30; Picture; BLOB)
        {
            Caption = 'Picture';
            SubType = Bitmap;
        }
        field(40; Icon; BLOB)
        {
            SubType = Bitmap;
        }
        field(50000; "Skip Delivery"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        ServiceLedger: Record "Service Ledger Entry EDMS";
        Model: Record Model;
        MakeSetup: Record "Make Setup";
    begin
        Model.RESET;
        Model.SETRANGE("Make Code", Code);
        IF Model.FINDFIRST THEN
            ERROR(Text001, TABLECAPTION, Code, Model.TABLECAPTION);

        ServiceLedger.RESET;
        ServiceLedger.SETCURRENTKEY("Make Code", "Model Code", "Model Version No.", "Posting Date");
        ServiceLedger.SETRANGE("Make Code", Code);
        IF ServiceLedger.FINDFIRST THEN
            ERROR(Text001, TABLECAPTION, Code, ServiceLedger.TABLECAPTION);

        IF MakeSetup.GET(Code) THEN
            MakeSetup.DELETE;
    end;

    trigger OnInsert()
    var
        MakeSetup: Record "Make Setup";
    begin
        MakeSetup.INIT;
        MakeSetup."Make Code" := Code;
        MakeSetup.INSERT;
    end;

    var
        Text001: Label 'You cannot delete %1 %2 because there is at least one %3 that includes this make.';
}


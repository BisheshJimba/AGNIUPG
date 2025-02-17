page 25006012 "Make Setup"
{
    // 16.05.2014 Elva Baltic P8 #S016 MMG7.00
    //   * added fields:
    //     Common
    // 
    // 03.03.2014 Elva Baltic P7 #R114 MMG7.00
    //   * Added Field "Service Warranty (years)"

    Caption = 'Make Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = Table25006050;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Default CM VAT Prod. Post. Grp"; "Default CM VAT Prod. Post. Grp")
                {
                }
                field("Use Vehicle Assemblies"; "Use Vehicle Assemblies")
                {
                }
                field("Process IC Inbox Documents"; "Process IC Inbox Documents")
                {
                }
                field("PDI Service Package No."; "PDI Service Package No.")
                {
                }
            }
            group(Numbering)
            {
                Caption = 'Numbering';
                field("Standard Option Nos."; "Standard Option Nos.")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    var
        TargetMakeCode: Code[20];
    begin
        TargetMakeCode := GETRANGEMIN("Make Code");

        RESET;
        IF NOT GET(TargetMakeCode) THEN BEGIN
            INIT;
            "Make Code" := TargetMakeCode;
            INSERT;
        END;
    end;
}


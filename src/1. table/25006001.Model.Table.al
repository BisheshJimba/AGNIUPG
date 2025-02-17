table 25006001 Model
{
    // 14.05.2014 Elva Baltic P21 #S0106 MMG7.00
    //   Added key:
    //     Commercial Name
    // 
    // 03.04.2014 Elva Baltic P1 #RX MMG7.00
    //   *Added FieldGroup DropDown
    // 
    // 10.05.2008. EDMS P2
    //   * Added code OnDelete

    Caption = 'Model';
    DataPerCompany = false;
    LookupPageID = "Model List";

    fields
    {
        field(10; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(20; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(30; "Commercial Name"; Text[50])
        {
            Caption = 'Commercial Name';
        }
        field(100; "View Sequence"; Integer)
        {
            Caption = 'View Sequence';
        }
        field(50000; Segment; Code[20])
        {
            TableRelation = "Vehicle Segment".Code;
        }
    }

    keys
    {
        key(Key1; "Make Code", "Code")
        {
            Clustered = true;
        }
        key(Key2; "View Sequence")
        {
        }
        key(Key3; "Commercial Name")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Make Code", "Code", "Commercial Name")
        {
        }
    }

    trigger OnDelete()
    var
        Item: Record Item;
        ServiceLedger: Record "Service Ledger Entry EDMS";
    begin
        /*Item.RESET;
        Item.SETCURRENTKEY("Item Type", "Make Code", "Model Code");
        Item.SETRANGE("Item Type", Item."Item Type"::"Model Version");
        Item.SETRANGE("Make Code", "Make Code");
        Item.SETRANGE("Model Code", Code);
        IF Item.FINDFIRST THEN
          ERROR(Text001, TABLECAPTION, Code, Item.TABLECAPTION);
        
        ServiceLedger.RESET;
        ServiceLedger.SETCURRENTKEY("Make Code", "Model Code", "Model Version No.", "Posting Date");
        ServiceLedger.SETRANGE("Make Code", "Make Code");
        ServiceLedger.SETRANGE("Model Code", Code);
        IF ServiceLedger.FINDFIRST THEN
          ERROR(Text001, TABLECAPTION, Code, ServiceLedger.TABLECAPTION);
         */

    end;

    var
        Text001: Label 'You cannot delete %1 %2 because there is at least one %3 that includes this model.';
}


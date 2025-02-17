table 25006050 "Make Setup"
{
    // 12.05.2008. EDMS P2
    //   * Added field "Vehicle Evaluation No. Series"
    // 
    // 10.09.2007 EDMS P3
    //   * Added fields for PutInTakeOut Source Codes: Service PutInTakeOut SC and Sale PutInTakeOut SC

    Caption = 'Make Setup';

    fields
    {
        field(10; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(40; "Standard Option Nos."; Code[10])
        {
            Caption = 'Standard Option Nos.';
            TableRelation = "No. Series";
        }
        field(50; "Default CM VAT Prod. Post. Grp"; Code[10])
        {
            Caption = 'Default CM VAT Prod. Posting Group';
            Description = 'If it is filled - Prepmt. CM posting use it for non-correction CMs';
            TableRelation = "VAT Product Posting Group";
        }
        field(60; "Use Vehicle Assemblies"; Boolean)
        {
            Caption = 'Use Vehicle Assemblies';
        }
        field(70; "Process IC Inbox Documents"; Boolean)
        {
            Caption = 'Process IC Inbox Documents';
            Description = 'When checked - is activated additional B2B processing when importing IC Purch. Orders in CU 427';
        }
        field(80; "PDI Service Package No."; Code[20])
        {
            Caption = 'PDI Service Package';
            TableRelation = "Service Package".No. WHERE(Make Code=FIELD(Make Code));
        }
    }

    keys
    {
        key(Key1;"Make Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


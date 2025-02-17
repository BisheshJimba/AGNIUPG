tableextension 50118 tableextension50118 extends "General Posting Setup"
{
    // 11.04.2008 EDMS P3
    //  * Added new field Veh. Add. Expenses Account for Vehicle Additional Expenses functionality
    fields
    {
        field(25006000; "Service Prepayments Account"; Code[20])
        {
            Caption = 'Service Prepayments Account';
            TableRelation = "G/L Account";
        }
        field(25006010; "Veh. Add. Expenses Account"; Code[20])
        {
            Caption = 'Veh. Add. Expenses Account';
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                CheckGLAcc("Veh. Add. Expenses Account");
            end;
        }
        field(25006020; "WIP Accured Cost Acc."; Code[10])
        {
            Caption = 'WIP Accured Cost Acc.';
        }
        field(25006030; "WIP Accured Sales Acc."; Code[10])
        {
            Caption = 'WIP Accured Sales Acc.';
        }
        field(25006040; "WIP Cost Adjustment Acc."; Code[10])
        {
            Caption = 'WIP Cost Adjustment Acc.';
        }
        field(25006050; "WIP Sales Adjusment Acc."; Code[10])
        {
            Caption = 'WIP Sales Adjusment Acc.';
        }
    }
}


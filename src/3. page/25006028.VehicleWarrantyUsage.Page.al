page 25006028 "Vehicle Warranty Usage"
{
    Caption = 'Vehicle Warranty Usage';
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006038;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Model Version No."; "Model Version No.")
                {
                }
                field("Vehicle Status Code"; "Vehicle Status Code")
                {
                }
                field("Warranty Type Code"; "Warranty Type Code")
                {
                }
                field("Term Date Formula"; "Term Date Formula")
                {
                }
                field("Kilometrage Limit"; "Kilometrage Limit")
                {
                }
                field("Variable Field Run 2"; "Variable Field Run 2")
                {
                }
                field("Variable Field Run 3"; "Variable Field Run 3")
                {
                }
                field(Description; Description)
                {
                }
                field("Spare Warranty"; "Spare Warranty")
                {
                }
                field(Item; Item)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        fSetVariableFields;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        fHideVariableFields;
    end;

    var
        [InDataSet]
        VFRun1Visible: Boolean;
        [InDataSet]
        VFRun2Visible: Boolean;
        [InDataSet]
        VFRun3Visible: Boolean;

    [Scope('Internal')]
    procedure fSetVariableFields()
    begin
        //Variable Fields
        VFRun1Visible := IsVFActive(FIELDNO("Kilometrage Limit"));
        VFRun2Visible := IsVFActive(FIELDNO("Variable Field Run 2"));
        VFRun3Visible := IsVFActive(FIELDNO("Variable Field Run 3"));
    end;

    [Scope('Internal')]
    procedure fHideVariableFields()
    begin
        //Variable Fields
        VFRun1Visible := FALSE;
        VFRun2Visible := FALSE;
        VFRun3Visible := FALSE;
    end;
}


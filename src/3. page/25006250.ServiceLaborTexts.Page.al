page 25006250 "Service Labor Texts"
{
    Caption = 'Service Labor Texts';
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006175;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Service Labor No."; "Service Labor No.")
                {
                }
                field("DMS Variable Field 25006800"; "Variable Field 25006800")
                {
                    Visible = DMSVariableField25006800Visibl;
                }
                field("DMS Variable Field 25006801"; "Variable Field 25006801")
                {
                    Visible = DMSVariableField25006801Visibl;
                }
                field(Description; Description)
                {
                }
                field("Description 2"; "Description 2")
                {
                }
                field("Description 3"; "Description 3")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        DMSVariableField25006801Visibl := TRUE;
        DMSVariableField25006800Visibl := TRUE;
    end;

    trigger OnOpenPage()
    begin
        fSetVariableFields
    end;

    var
        [InDataSet]
        DMSVariableField25006800Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006801Visibl: Boolean;

    [Scope('Internal')]
    procedure fSetVariableFields()
    begin
        //Variable Fields
        DMSVariableField25006800Visibl := IsVFActive(FIELDNO("Variable Field 25006800"));
        DMSVariableField25006801Visibl := IsVFActive(FIELDNO("Variable Field 25006801"));
    end;
}


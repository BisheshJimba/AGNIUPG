page 25006083 "VIN Decoding"
{
    Caption = 'VIN Decoding';
    PageType = List;
    SourceTable = Table25006008;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Entry No."; "Entry No.")
                {
                }
                field("Make Code"; "Make Code")
                {
                }
                field("Parent Entry No."; "Parent Entry No.")
                {
                }
                field("Primary Entry"; "Primary Entry")
                {
                }
                field(Position; Position)
                {
                }
                field(Combination; Combination)
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Model Version No."; "Model Version No.")
                {
                }
                field("Forbidden Symbols Field"; "Forbidden Symbols Field")
                {
                }
                field("VIN Lenght"; "VIN Lenght")
                {
                }
                field("Combination Value Field"; "Combination Value Field")
                {
                }
                field("Variable Field 25006800"; "Variable Field 25006800")
                {
                    Visible = DMSVariableField25006800Visibl;
                }
                field("Variable Field 25006801"; "Variable Field 25006801")
                {
                    Visible = DMSVariableField25006801Visibl;
                }
                field("Variable Field 25006802"; "Variable Field 25006802")
                {
                    Visible = DMSVariableField25006802Visibl;
                }
                field("Variable Field 25006803"; "Variable Field 25006803")
                {
                    Visible = DMSVariableField25006803Visibl;
                }
                field("Variable Field 25006804"; "Variable Field 25006804")
                {
                    Visible = DMSVariableField25006804Visibl;
                }
                field("Variable Field 25006805"; "Variable Field 25006805")
                {
                    Visible = DMSVariableField25006805Visibl;
                }
                field("Variable Field 25006806"; "Variable Field 25006806")
                {
                    Visible = DMSVariableField25006806Visibl;
                }
                field("Variable Field 25006807"; "Variable Field 25006807")
                {
                    Visible = DMSVariableField25006807Visibl;
                }
                field("Variable Field 25006808"; "Variable Field 25006808")
                {
                    Visible = DMSVariableField25006808Visibl;
                }
                field("Variable Field 25006809"; "Variable Field 25006809")
                {
                    Visible = DMSVariableField25006809Visibl;
                }
                field("Variable Field 25006810"; "Variable Field 25006810")
                {
                    Visible = DMSVariableField25006810Visibl;
                }
                field("Variable Field 25006811"; "Variable Field 25006811")
                {
                    Visible = DMSVariableField25006811Visibl;
                }
                field("Variable Field 25006812"; "Variable Field 25006812")
                {
                    Visible = DMSVariableField25006812Visibl;
                }
                field("Variable Field 25006813"; "Variable Field 25006813")
                {
                    Visible = DMSVariableField25006813Visibl;
                }
                field("Variable Field 25006814"; "Variable Field 25006814")
                {
                    Visible = DMSVariableField25006814Visibl;
                }
                field("Variable Field 25006815"; "Variable Field 25006815")
                {
                    Visible = DMSVariableField25006815Visibl;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnInit()
    begin
        DMSVariableField25006815Visibl := TRUE;
        DMSVariableField25006814Visibl := TRUE;
        DMSVariableField25006813Visibl := TRUE;
        DMSVariableField25006812Visibl := TRUE;
        DMSVariableField25006811Visibl := TRUE;
        DMSVariableField25006810Visibl := TRUE;
        DMSVariableField25006809Visibl := TRUE;
        DMSVariableField25006808Visibl := TRUE;
        DMSVariableField25006807Visibl := TRUE;
        DMSVariableField25006806Visibl := TRUE;
        DMSVariableField25006805Visibl := TRUE;
        DMSVariableField25006804Visibl := TRUE;
        DMSVariableField25006803Visibl := TRUE;
        DMSVariableField25006802Visibl := TRUE;
        DMSVariableField25006801Visibl := TRUE;
        DMSVariableField25006800Visibl := TRUE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    begin
        fSetVariableFields;
    end;

    var
        [InDataSet]
        DMSVariableField25006800Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006801Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006802Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006803Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006804Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006805Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006806Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006807Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006808Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006809Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006810Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006811Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006812Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006813Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006814Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006815Visibl: Boolean;

    [Scope('Internal')]
    procedure fSetVariableFields()
    begin
        //Variable Fields
        DMSVariableField25006800Visibl := IsVFActive(FIELDNO("Variable Field 25006800"));
        DMSVariableField25006801Visibl := IsVFActive(FIELDNO("Variable Field 25006801"));
        DMSVariableField25006802Visibl := IsVFActive(FIELDNO("Variable Field 25006802"));
        DMSVariableField25006803Visibl := IsVFActive(FIELDNO("Variable Field 25006803"));
        DMSVariableField25006804Visibl := IsVFActive(FIELDNO("Variable Field 25006804"));
        DMSVariableField25006805Visibl := IsVFActive(FIELDNO("Variable Field 25006805"));
        DMSVariableField25006806Visibl := IsVFActive(FIELDNO("Variable Field 25006806"));
        DMSVariableField25006807Visibl := IsVFActive(FIELDNO("Variable Field 25006807"));
        DMSVariableField25006808Visibl := IsVFActive(FIELDNO("Variable Field 25006808"));
        DMSVariableField25006809Visibl := IsVFActive(FIELDNO("Variable Field 25006809"));
        DMSVariableField25006810Visibl := IsVFActive(FIELDNO("Variable Field 25006810"));
        DMSVariableField25006811Visibl := IsVFActive(FIELDNO("Variable Field 25006811"));
        DMSVariableField25006812Visibl := IsVFActive(FIELDNO("Variable Field 25006812"));
        DMSVariableField25006813Visibl := IsVFActive(FIELDNO("Variable Field 25006813"));
        DMSVariableField25006814Visibl := IsVFActive(FIELDNO("Variable Field 25006814"));
        DMSVariableField25006815Visibl := IsVFActive(FIELDNO("Variable Field 25006815"));
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        fSetVariableFields;
    end;
}


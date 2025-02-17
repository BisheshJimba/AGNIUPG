page 25006001 "Model Version Specification"
{
    // 04.06.2007. EDMS P2
    //   * Created this form

    Caption = 'Model Version Specification';
    PageType = Card;
    PopulateAllFields = true;
    SourceTable = Table25006012;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Make Code"; "Make Code")
                {
                    Editable = false;
                }
                field("Model Code"; "Model Code")
                {
                    Editable = false;
                }
                field("Model Version No."; "Model Version No.")
                {
                    Editable = false;
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
                field("Variable Field 25006816"; "Variable Field 25006816")
                {
                    Visible = DMSVariableField25006816Visibl;
                }
                field("Variable Field 25006817"; "Variable Field 25006817")
                {
                    Visible = DMSVariableField25006817Visibl;
                }
                field("Variable Field 25006818"; "Variable Field 25006818")
                {
                    Visible = DMSVariableField25006818Visibl;
                }
                field("Variable Field 25006819"; "Variable Field 25006819")
                {
                    Visible = DMSVariableField25006819Visibl;
                }
                field("Variable Field 25006820"; "Variable Field 25006820")
                {
                    Visible = DMSVariableField25006820Visibl;
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
        OnAfterGetCurrRecord;
    end;

    trigger OnInit()
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        fHideVariableFields;
        OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    begin
        ModelVersionSpecification.COPYFILTERS(Rec);
        IF NOT ModelVersionSpecification.FINDSET THEN BEGIN
            SetGeneral(ModelVersionSpecification.GETRANGEMIN("Make Code"), ModelVersionSpecification.GETRANGEMIN("Model Code"),
                ModelVersionSpecification.GETRANGEMIN("Model Version No."));
        END;
    end;

    var
        ModelVersionSpecification: Record "25006012";
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
        [InDataSet]
        DMSVariableField25006816Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006817Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006818Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006819Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006820Visibl: Boolean;
        Text001: Label 'Would you like to create a specification?';

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
        DMSVariableField25006816Visibl := IsVFActive(FIELDNO("Variable Field 25006816"));
        DMSVariableField25006817Visibl := IsVFActive(FIELDNO("Variable Field 25006817"));
        DMSVariableField25006818Visibl := IsVFActive(FIELDNO("Variable Field 25006818"));
        DMSVariableField25006819Visibl := IsVFActive(FIELDNO("Variable Field 25006819"));
        DMSVariableField25006820Visibl := IsVFActive(FIELDNO("Variable Field 25006820"));
    end;

    [Scope('Internal')]
    procedure fHideVariableFields()
    begin
        //Variable Fields
        DMSVariableField25006800Visibl := FALSE;
        DMSVariableField25006801Visibl := FALSE;
        DMSVariableField25006802Visibl := FALSE;
        DMSVariableField25006803Visibl := FALSE;
        DMSVariableField25006804Visibl := FALSE;
        DMSVariableField25006805Visibl := FALSE;
        DMSVariableField25006806Visibl := FALSE;
        DMSVariableField25006807Visibl := FALSE;
        DMSVariableField25006808Visibl := FALSE;
        DMSVariableField25006809Visibl := FALSE;
        DMSVariableField25006810Visibl := FALSE;
        DMSVariableField25006811Visibl := FALSE;
        DMSVariableField25006812Visibl := FALSE;
        DMSVariableField25006813Visibl := FALSE;
        DMSVariableField25006814Visibl := FALSE;
        DMSVariableField25006815Visibl := FALSE;
        DMSVariableField25006816Visibl := FALSE;
        DMSVariableField25006817Visibl := FALSE;
        DMSVariableField25006818Visibl := FALSE;
        DMSVariableField25006819Visibl := FALSE;
        DMSVariableField25006820Visibl := FALSE;
    end;

    [Scope('Internal')]
    procedure SetGeneral(MakeCode: Code[20]; ModelCode: Code[20]; ModelVersion: Code[20])
    begin
        IF CONFIRM(Text001, TRUE) THEN BEGIN
            "Make Code" := MakeCode;
            "Model Code" := ModelCode;
            "Model Version No." := ModelVersion;
            INSERT;
        END;
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        fSetVariableFields;
    end;
}


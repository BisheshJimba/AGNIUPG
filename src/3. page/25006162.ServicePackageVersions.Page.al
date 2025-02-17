page 25006162 "Service Package Versions"
{
    AutoSplitKey = true;
    Caption = 'Service Package Version List';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = Table25006135;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Package No."; "Package No.")
                {
                    Visible = false;
                }
                field("Version No."; "Version No.")
                {
                    Visible = false;
                }
                field(Description; Description)
                {
                }
                field("Make Code"; "Make Code")
                {
                    Visible = false;
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Prod. Year From"; "Prod. Year From")
                {
                }
                field("Prod. Year To"; "Prod. Year To")
                {
                }
                field("VIN From"; "VIN From")
                {
                }
                field("VIN To"; "VIN To")
                {
                }
                field("Kilometrage To"; "Kilometrage To")
                {
                    Visible = VFRun1Visible;
                }
                field("Variable Field Run 2"; "Variable Field Run 2")
                {
                    Visible = VFRun2Visible;
                }
                field("Variable Field Run 3"; "Variable Field Run 3")
                {
                    Visible = VFRun3Visible;
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
                field(Amount; Amount)
                {

                    trigger OnDrillDown()
                    var
                        VersionSpec: Record "25006136";
                    begin
                        VersionSpec.RESET;
                        VersionSpec.SETRANGE("Package No.", "Package No.");
                        VersionSpec.SETRANGE("Version No.", "Version No.");
                        PAGE.RUNMODAL(PAGE::"Service Package Version Lines", VersionSpec);
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(VersionLines)
            {
                Caption = 'Version Lines';
                Image = Versions;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page 25006163;
                RunPageLink = Package No.=FIELD(Package No.),
                              Version No.=FIELD(Version No.);
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetVariableFields;
    end;

    trigger OnInit()
    begin
        DMSVariableField25006804Visibl := TRUE;
        DMSVariableField25006803Visibl := TRUE;
        DMSVariableField25006802Visibl := TRUE;
        DMSVariableField25006801Visibl := TRUE;
        DMSVariableField25006800Visibl := TRUE;
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
        VFRun1Visible: Boolean;
        [InDataSet]
        VFRun2Visible: Boolean;
        [InDataSet]
        VFRun3Visible: Boolean;

    [Scope('Internal')]
    procedure SetVariableFields()
    begin
        //Variable Fields
         DMSVariableField25006800Visibl := IsVFActive(FIELDNO("Variable Field 25006800"));
         DMSVariableField25006801Visibl := IsVFActive(FIELDNO("Variable Field 25006801"));
         DMSVariableField25006802Visibl := IsVFActive(FIELDNO("Variable Field 25006802"));
         DMSVariableField25006803Visibl := IsVFActive(FIELDNO("Variable Field 25006803"));
         DMSVariableField25006804Visibl := IsVFActive(FIELDNO("Variable Field 25006804"));
         VFRun1Visible := IsVFActive(FIELDNO("Kilometrage To"));
         VFRun2Visible := IsVFActive(FIELDNO("Variable Field Run 2"));
         VFRun3Visible := IsVFActive(FIELDNO("Variable Field Run 3"));
    end;
}


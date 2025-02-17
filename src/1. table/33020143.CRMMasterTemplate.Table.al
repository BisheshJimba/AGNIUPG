table 33020143 "CRM Master Template"
{
    Caption = 'CRM Master Template';

    fields
    {
        field(1; "Master Options"; Option)
        {
            Description = 'This field separates master templates.';
            OptionCaption = ' ,Time Line for Purchase,LeadSource,MediaMotivator,CustomerType,ProspectType,NeedAssessment,SalesProgress,FuelPreference,TestDrive,LostProspect,SSI,LostToInitial,C2 Sub Stages,Application';
            OptionMembers = " ","Time Line for Purchase",LeadSource,MediaMotivator,CustomerType,ProspectType,NeedAssessment,SalesProgress,FuelPreference,TestDrive,LostProspect,SSI,LostToInitial,"C2 Sub Stages",Application;
        }
        field(2; "Code"; Code[10])
        {
        }
        field(3; Description; Code[150])
        {
        }
        field(4; Active; Boolean)
        {
            Description = 'If not used (old ones) then untick this field.';

            trigger OnValidate()
            begin
                // CNY.CRM >>

                IF "Master Options" = "Master Options"::"C2 Sub Stages" THEN BEGIN
                    C2SubStages_G.RESET;
                    C2SubStages_G.SETRANGE(Code, Code);
                    C2SubStages_G.MODIFYALL(Active, Active);
                END;

                // CNY.CRM >>
            end;
        }
        field(20; Color; Code[10])
        {
            Description = 'This field is used only for Master Options C2 Sub Stages';
        }
        field(25; "Division Type"; Option)
        {
            OptionCaption = ' ,CVD,PCD';
            OptionMembers = " ",CVD,PCD;
        }
    }

    keys
    {
        key(Key1; "Master Options", "Code", "Division Type")
        {
            Clustered = true;
        }
        key(Key2; "Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Description)
        {
        }
    }

    trigger OnInsert()
    begin
        // CNY.CRM >>

        IF "Master Options" = "Master Options"::"C2 Sub Stages" THEN BEGIN
            C2SubStages_G.RESET;
            C2SubStages_G.SETRANGE(Code, Code);
            IF C2SubStages_G.ISEMPTY THEN BEGIN
                Contact_G.RESET;
                Contact_G.SETFILTER(Status, 'Active');
                IF Contact_G.FINDSET THEN
                    REPEAT
                        PipelineMgtDetails_G.RESET;
                        PipelineMgtDetails_G.SETRANGE("Prospect No.", Contact_G."No.");
                        IF PipelineMgtDetails_G.FINDSET THEN
                            REPEAT
                                C2SubStages_G.INIT;
                                C2SubStages_G."Prospect No." := Contact_G."No.";
                                C2SubStages_G."Prospect Line No." := PipelineMgtDetails_G."Line No.";
                                C2SubStages_G.Code := Code;
                                C2SubStages_G.Description := Description;
                                C2SubStages_G.Active := Active;
                                C2SubStages_G.Color := Color;
                                C2SubStages_G."Division Type" := "Division Type";
                                C2SubStages_G.INSERT;
                            UNTIL PipelineMgtDetails_G.NEXT = 0;
                    UNTIL Contact_G.NEXT = 0;
            END;
        END;

        IF UserSetup_G.GET(USERID) THEN BEGIN
            IF SalesPerson_G.GET(UserSetup_G."Salespers./Purch. Code") THEN
                "Division Type" := SalesPerson_G."Vehicle Division";
        END;

        // CNY.CRM >>
    end;

    var
        "------CNY.CRM-----------": Integer;
        LeadSource_G: Record "33020144";
        SalesProgress_G: Record "33020147";
        C2SubStages_G: Record "33020152";
        Contact_G: Record "5050";
        PipelineMgtDetails_G: Record "33020141";
        UserSetup_G: Record "91";
        SalesPerson_G: Record "13";
}


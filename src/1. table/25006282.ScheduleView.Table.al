table 25006282 "Schedule View"
{
    // 16.05.2013 EDMS P8
    //   * Added field "Time Grid Item Code"

    Caption = 'Schedule View';
    LookupPageID = 25006375;

    fields
    {
        field(10; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(20; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(30; "Show as Lines"; Text[30])
        {
            Caption = 'Show as Lines';
            Description = 'Classic Client';

            trigger OnLookup()
            var
                NewCode: Text[30];
            begin
                NewCode := GetDimSelection("Show as Lines");
                IF NewCode <> "Show as Lines" THEN
                    "Show as Lines" := NewCode;
            end;
        }
        field(40; "Lines Parameter"; Code[10])
        {
            Caption = 'Lines Parameter';
            Description = 'Classic Client';

            trigger OnLookup()
            begin
                CASE "Show as Lines" OF
                    Text010:
                        VALIDATE("Lines Parameter", GetResGrpSelection("Lines Parameter"));
                    Text011:
                        VALIDATE("Lines Parameter", GetTimeGridSelection("Lines Parameter"));
                END;
            end;
        }
        field(50; "Show as Columns"; Text[30])
        {
            Caption = 'Show as Columns';
            Description = 'Classic Client';
            TableRelation = "Dimension Selection Buffer";

            trigger OnLookup()
            var
                NewCode: Text[30];
            begin
                NewCode := GetDimSelection("Show as Columns");
                IF NewCode <> "Show as Columns" THEN
                    "Show as Columns" := NewCode;
            end;
        }
        field(60; "Columns Parameter"; Code[10])
        {
            Caption = 'Columns Parameter';
            Description = 'Classic Client';

            trigger OnLookup()
            begin
                CASE "Show as Columns" OF
                    Text010:
                        VALIDATE("Columns Parameter", GetResGrpSelection("Columns Parameter"));
                    Text011:
                        VALIDATE("Columns Parameter", GetTimeGridSelection("Columns Parameter"));
                END;
            end;
        }
        field(80; "Group by"; Option)
        {
            Caption = 'Group by';
            OptionCaption = ' ,Workplace,Skill,Shift';
            OptionMembers = " ",Workplace,Skill,Shift;
        }
        field(200; "Resource Group"; Code[10])
        {
            Caption = 'Resource Group';
            TableRelation = "Schedule Resource Group";
        }
        field(210; "Period Type"; Option)
        {
            Caption = 'Period Type';
            OptionCaption = 'Custom,Day,Week,Month';
            OptionMembers = Custom,Day,Week,Month;
        }
        field(300; "Start Date Formula"; DateFormula)
        {
            Caption = 'Start Date Formula';
        }
        field(400; "Start Time"; Time)
        {
            Caption = 'Start Time';
            Description = 'RTC only';
        }
        field(410; "End Time"; Time)
        {
            Caption = 'End Time';
            Description = 'RTC only';
        }
        field(420; "Time Grid Code"; Code[20])
        {
            Caption = 'Time Grid Code';
            Description = 'RTC only';
            TableRelation = "Time Grid";
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Text000: Label 'Day Period';
        Text010: Label 'Resource';
        Text011: Label 'Time Period';

    local procedure GetDimSelection(OldDimGrpCode: Text[30]): Text[30]
    var
        DimSelection: Page "568";
    begin

        DimSelection.InsertDimSelBuf(FALSE, Text010, Text010);
        DimSelection.InsertDimSelBuf(FALSE, Text000, Text000);
        DimSelection.InsertDimSelBuf(FALSE, Text011, Text011);

        DimSelection.LOOKUPMODE := TRUE;
        IF DimSelection.RUNMODAL = ACTION::LookupOK THEN
            EXIT(DimSelection.GetDimSelCode)
        ELSE
            EXIT(OldDimGrpCode);
    end;

    local procedure GetResGrpSelection(OldDimSelCode: Text[30]): Text[30]
    var
        ResourceGroup: Record "25006274";
        ResourceGroups: Page "72";
    begin
        ResourceGroups.LOOKUPMODE := TRUE;
        IF ResourceGroups.RUNMODAL = ACTION::LookupOK THEN BEGIN
            ResourceGroups.GETRECORD(ResourceGroup);
            EXIT(ResourceGroup.Code)
        END
        ELSE
            EXIT(OldDimSelCode);
    end;

    local procedure GetTimeGridSelection(OldDimSelCode: Text[30]): Text[30]
    var
        TimeViews: Page "25006367";
        TimeView: Record "25006278";
    begin
        TimeViews.LOOKUPMODE := TRUE;
        IF TimeViews.RUNMODAL = ACTION::LookupOK THEN BEGIN
            TimeViews.GETRECORD(TimeView);
            EXIT(TimeView.Code)
        END
        ELSE
            EXIT(OldDimSelCode);
    end;

    [Scope('Internal')]
    procedure FilterOnView(): Code[10]
    var
        UserProfileSetup: Record "25006067";
        UserSetup: Record "91";
    begin
        IF UserSetup.GET(USERID) THEN BEGIN
            IF UserProfileSetup.GET(UserSetup."Default User Profile Code") THEN BEGIN
                EXIT(UserProfileSetup."Service Schedule View Code");
            END;
        END;
        EXIT('');
    end;
}


page 33020507 "Payroll Components"
{
    PageType = List;
    SourceTable = Table33020503;
    SourceTableView = SORTING(Column No.);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Column Name"; "Column Name")
                {
                }
                field(Code; Code)
                {
                }
                field(Description; Description)
                {
                }
                field(Type; Type)
                {
                }
                field(Subtype; Subtype)
                {
                }
                field(Formula; Formula)
                {
                }
                field("G/L Account"; "G/L Account")
                {
                }
                field("Posting Method"; "Posting Method")
                {
                }
                field("Applicable Month"; "Applicable Month")
                {
                    Enabled = editablecontrol2;

                    trigger OnValidate()
                    begin
                        IF ("Applicable Month" <> "Applicable Month"::" ") THEN
                            EditableControl1 := FALSE
                        ELSE
                            EditableControl1 := TRUE;
                    end;
                }
                field("Applicable from"; "Applicable from")
                {
                    Editable = EditableControl1;

                    trigger OnValidate()
                    begin
                        IF ("Applicable from" <> 0D) OR ("Applicable to" <> 0D) THEN
                            EditableControl2 := FALSE
                        ELSE
                            EditableControl2 := TRUE;
                    end;
                }
                field("Applicable to"; "Applicable to")
                {
                    Editable = EditableControl1;

                    trigger OnValidate()
                    begin
                        IF ("Applicable to" <> 0D) OR ("Applicable to" <> 0D) THEN
                            EditableControl2 := FALSE
                        ELSE
                            EditableControl2 := TRUE;
                    end;
                }
                field("Usage Flexible"; "Usage Flexible")
                {
                }
                field("Plan Flexible"; "Plan Flexible")
                {
                }
                field(Fixed; Fixed)
                {
                }
                field(Status; Status)
                {
                }
                field("Apply Every Month"; "Apply Every Month")
                {
                }
                field("Deduct on Absent"; "Deduct on Absent")
                {
                }
                field("Tax Credit Amount"; "Tax Credit Amount")
                {
                }
                field("Tax Credit %"; "Tax Credit %")
                {
                }
                field("Current Month Tax Application"; "Current Month Tax Application")
                {
                }
                field("Retirement Investment"; "Retirement Investment")
                {
                    Caption = 'Is CIT?';
                }
                field("Enable % wise calculation"; "Enable % wise calculation")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
            }
            systempart(; Links)
            {
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        IF ("Applicable Month" <> "Applicable Month"::" ") THEN
            EditableControl1 := FALSE
        ELSE
            EditableControl1 := TRUE;

        IF ("Applicable from" <> 0D) OR ("Applicable to" <> 0D) THEN
            EditableControl2 := FALSE
        ELSE
            EditableControl2 := TRUE;
    end;

    var
        [InDataSet]
        EditableControl1: Boolean;
        [InDataSet]
        EditableControl2: Boolean;
}


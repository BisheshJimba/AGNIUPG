page 33020442 "Posted Employee Activity List"
{
    Caption = 'Posted Employee Activity List';
    Editable = false;
    PageType = List;
    SourceTable = Table33020401;
    SourceTableView = WHERE(Posted = CONST(Yes));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Activity No."; "Activity No.")
                {
                    Editable = false;

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit() THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Employee Name"; "Employee Name")
                {
                    Editable = false;
                }
                field(Activity; Activity)
                {
                }
                field("Effective Date"; "Effective Date")
                {
                    Editable = false;
                }
                field("To Branch"; "To Branch")
                {
                    Editable = false;
                }
                field("To Department"; "To Department")
                {
                    Editable = false;
                }
                field("To Job Title"; "To Job Title")
                {
                    Editable = false;
                }
                field("To Grade"; "To Grade")
                {
                    Editable = false;
                }
                field("To Manager Name"; "To Manager Name")
                {
                    Editable = false;
                }
                field("Basic Pay"; "Basic Pay")
                {
                }
                field("Dearness Allowance"; "Dearness Allowance")
                {
                }
                field("Other Allowance"; "Other Allowance")
                {
                }
                field(Total; Total)
                {
                }
                field("PF Percent"; "PF Percent")
                {
                }
                field(Remark; Remark)
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
            }
        }
    }

    actions
    {
    }

    var
        ActivityRec: Record "33020401";
}


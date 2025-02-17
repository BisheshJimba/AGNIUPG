page 33020362 "Training Request Subform"
{
    AutoSplitKey = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = Table33020360;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Part. Employee"; "Part. Employee")
                {

                    trigger OnValidate()
                    begin
                        EmpRec.SETRANGE(EmpRec."No.", "Part. Employee");
                        IF EmpRec.FIND('-') THEN
                            "Part. Employee Name" := EmpRec."Full Name";
                    end;
                }
                field("Part. Employee Name"; "Part. Employee Name")
                {
                    Editable = false;
                }
                field("Participant from Organization"; "Participant from Organization")
                {
                }
                field("Training Topic"; "Training Topic")
                {
                    Visible = false;
                }
                field("Tr. No."; "Tr. No.")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    var
        EmpRec: Record "5200";
}


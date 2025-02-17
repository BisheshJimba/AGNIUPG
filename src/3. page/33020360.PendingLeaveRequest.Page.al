page 33020360 "Pending Leave Request"
{
    CardPageID = "Posted Leave Request Card";
    PageType = List;
    SourceTable = Table33020344;
    SourceTableView = SORTING(Employee No., Leave Start Date)
                      ORDER(Ascending)
                      WHERE(Approved = CONST(No),
                            Rejected = CONST(No));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee No."; "Employee No.")
                {
                }
                field("Leave Description"; "Leave Description")
                {
                }
                field("Leave Start Date"; "Leave Start Date")
                {
                }
                field("Leave End Date"; "Leave End Date")
                {
                }
                field(Remarks; Remarks)
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
        EmpRec.RESET;
        EmpRec.SETRANGE("No.", "Employee No.");
        IF EmpRec.FIND('-') THEN BEGIN
            EmpName := EmpRec."First Name" + ' ' + EmpRec."Middle Name" + ' ' + EmpRec."Last Name";
        END;
    end;

    var
        EmpRec: Record "5200";
        EmpName: Text[250];
}


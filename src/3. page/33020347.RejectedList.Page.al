page 33020347 "Rejected List"
{
    CardPageID = "Application New Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33020382;
    SourceTableView = SORTING(Application No.)
                      ORDER(Ascending)
                      WHERE(Status = CONST(Reject));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Application No."; "Application No.")
                {
                }
                field("First Name"; "First Name")
                {
                }
                field("Phone No."; Telephone)
                {
                }
                field("Mobile No."; CellPhone)
                {
                }
                field(Email; Email)
                {
                }
                field(Status; Status)
                {
                }
                field("Vacancy No."; "Vacancy No.")
                {
                }
                field("Rejected Date"; "Posted Date- Reject")
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
        ApplicationNew.SETRANGE(ApplicationNew."Application No.", "Application No.");
        IF ApplicationNew.FINDFIRST THEN BEGIN
            Employed := ApplicationNew.Employed;
        END;
    end;

    var
        ApplicationNew: Record "33020382";
        Employed: Boolean;
}


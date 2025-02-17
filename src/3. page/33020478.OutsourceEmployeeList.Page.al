page 33020478 "Outsource Employee List"
{
    PageType = List;
    SourceTable = Table33020414;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Outsource Employee No."; "Outsource Employee No.")
                {

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit() THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Full Name"; "Full Name")
                {
                }
                field(Department; Department)
                {
                }
                field("Department Name"; "Department Name")
                {
                }
                field(Branch; Branch)
                {
                }
                field("Branch Name"; "Branch Name")
                {
                }
                field(Service; Service)
                {
                }
                field(Company; Company)
                {
                }
                field(Address; Address)
                {
                }
                field("Phone No."; "Phone No.")
                {
                }
                field(Qualification; Qualification)
                {
                }
                field("Joined Date"; "Joined Date")
                {
                }
                field("Left Date"; "Left Date")
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
}


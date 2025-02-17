page 33020072 "Loan Approval Check List Setup"
{
    PageType = List;
    SourceTable = Table33020068;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                }
                field(Description; Description)
                {
                }
                field("Description 2"; "Description 2")
                {
                }
                field(Mandatory; Mandatory)
                {
                }
                field("Application Status"; "Application Status")
                {
                }
                field(Blocked; Blocked)
                {
                }
            }
        }
    }

    actions
    {
    }
}


page 25006556 "My Contacts"
{
    PageType = ListPart;
    SourceTable = Table5050;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    Visible = false;
                }
                field(Name; Name)
                {
                }
                field("Phone No."; "Phone No.")
                {
                }
                field("E-Mail"; "E-Mail")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Contact Details")
            {
                Image = CustomerContact;
                RunObject = Page 5050;
                RunPageLink = No.=FIELD(No.);
            }
        }
    }

    trigger OnInit()
    begin
        IF UserSetup.GET(USERID) THEN
          IF UserSetup."Salespers./Purch. Code" <> '' THEN
            Rec.SETFILTER("Salesperson Code",UserSetup."Salespers./Purch. Code");
    end;

    var
        UserSetup: Record "91";
}


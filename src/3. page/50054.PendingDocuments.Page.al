page 50054 "Pending Documents"
{
    PageType = List;
    SourceTable = Table33019979;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Pending Transfers"; "Pending Transfers")
                {
                }
                field("Pending Sales"; "Pending Sales")
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
        SETFILTER("User Filter", USERID);
    end;

    trigger OnInit()
    begin
        RESET;
        IF NOT GET THEN BEGIN
            INIT;
            INSERT;
        END;
    end;

    trigger OnOpenPage()
    begin
        SETFILTER("User Filter", USERID);
    end;
}


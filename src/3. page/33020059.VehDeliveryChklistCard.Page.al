page 33020059 "Veh. Delivery Chklist Card"
{
    PageType = Card;
    SourceTable = Table33019854;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Vendor No."; "Vendor No.")
                {
                }
                field(Name; Name)
                {
                }
                field("Name 2"; "Name 2")
                {
                }
                field(Model; Model)
                {
                }
                field(VIN; VIN)
                {
                }
                field(Kilometrage; Kilometrage)
                {
                }
                field("Engine No."; "Engine No.")
                {
                }
                field("Delivery Date"; "Delivery Date")
                {
                }
            }
            part(; 33020060)
            {
                SubPageLink = No.=FIELD(No.);
            }
        }
    }

    actions
    {
    }
}


page 33020275 "Exempt Purchase Nos."
{
    PageType = Card;
    SourceTable = Table33020189;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Exempt No."; "Exempt No.")
                {

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field(Description; Description)
                {
                }
            }
        }
    }

    actions
    {
    }
}


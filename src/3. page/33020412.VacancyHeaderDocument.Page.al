page 33020412 "Vacancy Header Document"
{
    PageType = Document;
    SourceTable = Table33020380;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Vacancy No"; "Vacancy No")
                {

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit() THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Vacancy Type"; "Vacancy Type")
                {
                }
                field("Posted Date"; "Posted Date")
                {
                    Editable = false;
                }
                field("Posted By"; "Posted By")
                {
                    Editable = false;
                }
            }
            part(; 33020411)
            {
                SubPageLink = Vacancy No=FIELD(Vacancy No);
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
        area(processing)
        {
            action(Post)
            {
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    IF NOT CONFIRM('Do you want to confirm Vaccency Post?', FALSE) THEN
                        EXIT;

                    "Posted By" := USERID;
                    "Posted Date" := TODAY;
                    MODIFY;
                    MESSAGE('Vaccency Posted successfully.')
                end;
            }
        }
    }

    var
        ApplicationNew: Record "33020382";
        TotalEmployed: Integer;
        VacancyLine: Record "33020381";
}


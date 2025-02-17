page 33020452 "Outsource Staff Card"
{
    PageType = Card;
    SourceTable = Table33020404;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Outsource No."; "Outsource No.")
                {

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit() THEN
                            CurrPage.UPDATE;
                    end;
                }
                field(Name; Name)
                {
                }
                field(Company; Company)
                {
                }
                field(Service; Service)
                {
                }
                field("Contract ID"; "Contract ID")
                {
                }
                field("AMN No."; "AMN No.")
                {
                }
                field("Effective Date"; "Effective Date")
                {
                }
                field(Premises; Premises)
                {
                }
                field("No."; "No.")
                {
                }
                field(Type; Type)
                {
                }
                field(Deployment; Deployment)
                {
                }
                field(Category; Category)
                {
                }
                field("Rate / Month"; "Rate / Month")
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
        area(processing)
        {
            action("<Action1000000017>")
            {
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    OutsourceRec.SETRANGE(OutsourceRec."Outsource No.", "Outsource No.");
                    IF OutsourceRec.FINDFIRST THEN BEGIN
                        IF OutsourceRec.Posted = FALSE THEN BEGIN
                            OutsourceRec.Posted := TRUE;
                            OutsourceRec."Posted Date" := TODAY;
                            OutsourceRec."Posted By" := USERID;
                            OutsourceRec.MODIFY;
                            MESSAGE(text0001);
                        END ELSE BEGIN
                            MESSAGE(text0002);
                        END;
                    END;
                end;
            }
        }
    }

    var
        OutsourceRec: Record "33020404";
        text0001: Label 'Outsource Staff Record Inseerted Successfully!';
        text0002: Label 'Record Updated Successfully!!';
}


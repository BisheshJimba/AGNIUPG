page 25006245 "Recall Campaign Card"
{
    Caption = 'Recall Campaign Card';
    PageType = Card;
    PopulateAllFields = true;
    SourceTable = Table25006162;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; "No.")
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
                field("Description 2"; "Description 2")
                {
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("Ending Date"; "Ending Date")
                {
                }
                field(Active; Active)
                {
                }
                field("Search Description"; "Search Description")
                {
                }
                field("External No."; "External No.")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("C&ampaign")
            {
                Caption = 'C&ampaign';
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page 25006187;
                    RunPageLink = Type = CONST(Recall Campaign),
                                  No.=FIELD(No.);
                }
                action(Vehicles)
                {
                    Caption = 'Vehicles';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page 25006247;
                                    RunPageLink = Campaign No.=FIELD(No.);
                }
                action("Service Packages")
                {
                    Caption = 'Service Packages';
                    Image = ServiceItemGroup;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ServPackage: Record "25006134";
                    begin
                        ServPackage.RESET;
                        ServPackage.SETCURRENTKEY("Recall Campaign No.");
                        ServPackage.SETRANGE("Recall Campaign No.","No.");
                        IF ServPackage.COUNT = 1 THEN
                          PAGE.RUNMODAL(PAGE::"Service Package Card", ServPackage)
                        ELSE
                          PAGE.RUNMODAL(PAGE::"Service Package List", ServPackage);
                    end;
                }
            }
        }
    }
}


page 25006076 "Service Line EDMS List"
{
    Caption = 'Service Line List';
    Editable = false;
    PageType = List;
    SourceTable = Table25006146;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Line No."; "Line No.")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Document Type"; "Document Type")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field(Type; Type)
                {
                }
                field("No."; "No.")
                {
                }
                field("Location Code"; "Location Code")
                {
                    Visible = false;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                }
                field("Job No."; "Job No.")
                {
                    Visible = false;
                }
                field(Quantity; Quantity)
                {
                }
                field("Quantity (Base)"; "Quantity (Base)")
                {
                }
                field("Outstanding Qty. (Base)"; "Outstanding Qty. (Base)")
                {
                }
                field("Line Amount"; "Line Amount")
                {
                }
                field("Line Discount %"; "Line Discount %")
                {
                }
                field("Line Discount Amount"; "Line Discount Amount")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action("Show Document")
                {
                    Caption = 'Show Document';
                    Image = View;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        IF ServHeader.GET("Document Type", "Document No.") THEN
                            CASE "Document Type" OF
                                "Document Type"::Quote:
                                    PAGE.RUN(PAGE::"Service Quote EDMS", ServHeader);
                                "Document Type"::Order:
                                    PAGE.RUN(PAGE::"Service Order EDMS", ServHeader);
                            END;
                    end;
                }
            }
        }
    }

    var
        ServHeader: Record "25006145";
}


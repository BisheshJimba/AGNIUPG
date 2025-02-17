page 25006161 "Service Package List"
{
    Caption = 'Service Package List';
    CardPageID = "Service Package Card";
    Editable = false;
    PageType = List;
    SourceTable = Table25006134;

    layout
    {
        area(content)
        {
            repeater()
            {
                field(Type; Type)
                {
                    Visible = false;
                }
                field("Make Code"; "Make Code")
                {
                    Visible = false;
                }
                field("No."; "No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Description 2"; "Description 2")
                {
                    Visible = false;
                }
                field("Search Description"; "Search Description")
                {
                }
                field("Group Code"; "Group Code")
                {
                    Visible = false;
                }
                field("Subgroup Code"; "Subgroup Code")
                {
                    Visible = false;
                }
                field("Recall Campaign No."; "Recall Campaign No.")
                {
                }
                field("Campaign No."; "Campaign No.")
                {
                    Visible = false;
                }
                field("Free of Charge"; "Free of Charge")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    [Scope('Internal')]
    procedure GetSelectionFilter(): Text
    var
        ServicePackage: Record "25006134";
        SelectionFilterManagement: Codeunit "46";
    begin
        CurrPage.SETSELECTIONFILTER(ServicePackage);
        EXIT(SelectionFilterManagement.GetSelectionFilterForServicePackage(ServicePackage));
    end;
}


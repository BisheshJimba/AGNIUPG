page 25006158 "Service Line Resources"
{
    // 12.05.2015 EB.P30 #T030
    //   Added fields:
    //     "Unit Cost"
    //     "Finished Cost Amount"
    //     "Remaining Cost Amount"
    //     "Total Cost Amount"

    Caption = 'Service Line Resources';
    PageType = List;
    SourceTable = Table25006277;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Resource No."; "Resource No.")
                {
                }
                field("Finished Quantity (Hours)"; "Finished Quantity (Hours)")
                {
                }
                field("Remaining Quantity (Hours)"; "Remaining Quantity (Hours)")
                {
                }
                field("Unit Cost"; "Unit Cost")
                {
                }
                field("Finished Cost Amount"; "Finished Cost Amount")
                {
                }
                field("Remaining Cost Amount"; "Remaining Cost Amount")
                {
                }
                field("Cost Amount"; "Cost Amount")
                {
                }
                field(Travel; Travel)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnDeleteRecord(): Boolean
    begin
        IF ServLaborAllocationEntry.GET("Allocation Entry No.") THEN
            ERROR(Text001);
    end;

    var
        ServiceSetup: Record "25006120";
        ServLaborAllocationEntry: Record "25006271";
        Text001: Label 'This is not allowed to delete allocated records.';
}


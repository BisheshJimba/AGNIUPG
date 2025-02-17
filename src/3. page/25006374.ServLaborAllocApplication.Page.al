page 25006374 "Serv. Labor Alloc. Application"
{
    // 12.05.2015 EB.P30 #T030
    //   Added fields:
    //     "Unit Cost"
    //     "Finished Cost Amount"
    //     "Remaining Cost Amount"
    //     "Total Cost Amount"

    Caption = 'Serv. Labor Alloc. Application';
    PageType = List;
    SourceTable = Table25006277;

    layout
    {
        area(content)
        {
            repeater()
            {
                Editable = false;
                field("Document Type"; "Document Type")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("Document Line No."; "Document Line No.")
                {
                }
                field(GetLaborNo; GetLaborNo)
                {
                    Caption = 'Labor No.';
                }
                field(GetLaborDescription; GetLaborDescription)
                {
                    Caption = 'Labor Description';
                }
                field("Resource No."; "Resource No.")
                {
                }
                field("Finished Quantity (Hours)"; "Finished Quantity (Hours)")
                {
                }
                field("Remaining Quantity (Hours)"; "Remaining Quantity (Hours)")
                {
                }
                field("Time Line"; "Time Line")
                {
                }
                field("Allocation Entry No."; "Allocation Entry No.")
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
        area(navigation)
        {
            group(Allocation)
            {
                Caption = 'Allocation';
                action("Show in Schedule")
                {
                    Caption = 'Show in Schedule';
                    Image = Planning;

                    trigger OnAction()
                    var
                        ServiceSchedule: Page "25006358";
                        ServLaborAllocation: Record "25006271";
                    begin
                        ServLaborAllocation.GET("Allocation Entry No.");
                        ServiceSchedule.SetAllocation(ServLaborAllocation);
                        ServiceSchedule.RUNMODAL;
                    end;
                }
            }
        }
    }

    [Scope('Internal')]
    procedure GetLaborNo(): Code[20]
    var
        ServiceLine: Record "25006146";
        PostedServiceLine: Record "25006150";
    begin
        IF ServiceLine.GET("Document Type", "Document No.", "Document Line No.") THEN
            EXIT(ServiceLine."No.");
        IF PostedServiceLine.GET("Document No.", "Document Line No.") THEN
            EXIT(PostedServiceLine."No.");

        EXIT('');
    end;

    [Scope('Internal')]
    procedure GetLaborDescription(): Text[50]
    var
        ServiceLine: Record "25006146";
        PostedServiceLine: Record "25006150";
    begin
        IF ServiceLine.GET("Document Type", "Document No.", "Document Line No.") THEN
            EXIT(ServiceLine.Description);
        IF PostedServiceLine.GET("Document No.", "Document Line No.") THEN
            EXIT(PostedServiceLine.Description);

        EXIT('');
    end;
}


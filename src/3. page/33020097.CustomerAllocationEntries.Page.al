page 33020097 "Customer Allocation Entries"
{
    AutoSplitKey = false;
    PageType = List;
    SourceTable = Table33019860;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    Editable = false;
                }
                field("Sales Order No."; "Sales Order No.")
                {
                    Editable = false;
                }
                field("Model Version No."; "Model Version No.")
                {
                    Editable = false;
                }
                field("Model Version Desc"; "Model Version Desc")
                {
                }
                field(Applied; Applied)
                {
                    Editable = false;
                }
                field("Customer No."; "Customer No.")
                {
                }
                field(Name; Name)
                {
                }
                field("Booked Date"; "Booked Date")
                {
                    Editable = false;
                }
                field("Quote No."; "Quote No.")
                {
                }
                field("User ID"; "User ID")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("<Action1000000013>")
                {
                    Caption = 'Set Applies ID';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        CheckAppliedEntries;

                        CustAllocationEntries.RESET;
                        CustAllocationEntries.SETRANGE(Applied, FALSE);
                        CurrPage.SETSELECTIONFILTER(CustAllocationEntries);
                        IF CustAllocationEntries.FINDFIRST THEN BEGIN
                            CustAllocationEntries.Applied := TRUE;
                            CustAllocationEntries.MODIFY;
                        END;
                    end;
                }
                action("<Action1000000012>")
                {
                    Caption = 'Unapply ID';

                    trigger OnAction()
                    begin
                        CustAllocationEntries.RESET;
                        CustAllocationEntries.SETRANGE(Applied, TRUE);
                        IF CustAllocationEntries.FINDFIRST THEN
                            CustAllocationEntries.Applied := FALSE;
                        CustAllocationEntries.MODIFY;
                    end;
                }
            }
        }
    }

    var
        CustAllocationEntries: Record "33019860";
        SalesHeader: Record "36";
        SalesOrder: Page "42";

    [Scope('Internal')]
    procedure CheckAppliedEntries(): Boolean
    var
        AppliedEntryExists: Label 'There is already a customer %1 applied  for this vehicle. Please unapply the entry to proceed.';
    begin
        CustAllocationEntries.RESET;
        CustAllocationEntries.SETRANGE(Applied, TRUE);
        IF CustAllocationEntries.FINDFIRST THEN BEGIN
            REPEAT
                IF CustAllocationEntries.Applied = TRUE THEN
                    ERROR(AppliedEntryExists, CustAllocationEntries."Customer No.")
             UNTIL CustAllocationEntries.NEXT = 0;
        END;
    end;
}


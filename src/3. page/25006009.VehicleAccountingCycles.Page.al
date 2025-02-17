page 25006009 "Vehicle Accounting Cycles"
{
    Caption = 'Vehicle Reserve Entries';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table25006024;

    layout
    {
        area(content)
        {
            repeater()
            {
                Editable = false;
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                    Visible = false;
                }
                field("No."; "No.")
                {
                    Visible = false;
                }
                field(VIN; VIN)
                {
                    Visible = false;
                }
                field(Default; Default)
                {
                    Visible = false;
                }
                field("Sales order"; "Sales order")
                {
                }
                field("Requisition Line"; "Requisition Line")
                {
                    Caption = 'Order Promised (Req. Worksheet)';
                }
                field("Purchase order"; "Purchase order")
                {
                }
                field("Customer No"; "Customer No")
                {
                }
                field("Customer Name"; "Customer Name")
                {
                }
                field("Vehicle In"; "Vehicle In")
                {
                }
                field("Vehicle Out"; "Vehicle Out")
                {
                }
                field(Make; Make)
                {
                }
                field(Model; Model)
                {
                }
                field("Model Version No."; "Model Version No.")
                {
                }
                field("Variant Code"; "Variant Code")
                {
                }
                field("Booked Date"; "Booked Date")
                {
                }
                field("PDI Status"; "PDI Status")
                {
                }
                field("PDI Type"; "PDI Type")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Accounting Cycle")
            {
                Caption = 'Accounting Cycle';
                action("Set As Default")
                {
                    Caption = 'Set As Default';
                    Image = Default;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        VehAccCycleMgt: Codeunit "25006303";
                    begin
                        TESTFIELD(Default, FALSE);
                        VehAccCycleMgt.SetAsDefault(Rec);
                    end;
                }
                action("<Action1000000012>")
                {
                    Caption = 'Count Records';
                    Image = CalculatePlan;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        CountRec := COUNT;
                        MESSAGE('No. of records are %1 ', CountRec);
                    end;
                }
                action("Create New")
                {
                    Caption = 'Create New';
                    Image = New;
                    Promoted = true;
                    PromotedCategory = New;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        VehAccCycleMgt: Codeunit "25006303";
                        VehAccCycleTemp: Record "25006024" temporary;
                    begin
                        IF "No." = '' THEN BEGIN
                            VehAccCycleTemp.INIT;
                            VehAccCycleTemp."Vehicle Serial No." := GETRANGEMIN("Vehicle Serial No.");
                            VehAccCycleMgt.CreateNewCycle_User(VehAccCycleTemp)
                        END
                        ELSE
                            VehAccCycleMgt.CreateNewCycle_User(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin

        /*customer.RESET;
        CALCFIELDS("Customer No");
        customer.SETRANGE("No.","Customer No");
        IF customer.FINDFIRST THEN BEGIN
          "Customer Name" := customer.Name;
        END;
        */

    end;

    trigger OnOpenPage()
    begin

        CALCFIELDS("Sales order");
        SETFILTER("Sales order", '<>%1', '');
    end;

    var
        customer: Record "18";
        CountRec: Integer;
}


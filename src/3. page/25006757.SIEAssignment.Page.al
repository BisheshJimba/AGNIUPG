page 25006757 "SIE Assignment"
{
    AutoSplitKey = true;
    Caption = 'SIE Assignment';
    DelayedInsert = true;
    PageType = Worksheet;
    PopulateAllFields = true;
    SourceTable = Table25006706;
    SourceTableView = SORTING(Applies-to Type, Applies-to Doc. Type, Applies-to Doc. No., Line No.)
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Applies-to Doc. Type"; "Applies-to Doc. Type")
                {
                }
                field("Applies-to Doc. No."; "Applies-to Doc. No.")
                {
                }
                field("Applies-to Doc. Line No."; "Applies-to Doc. Line No.")
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Qty. to Assign"; "Qty. to Assign")
                {

                    trigger OnValidate()
                    begin
                        UpdateQtyAssgnt;
                    end;
                }
                field("Doc. Qty. Assigned"; "Doc. Qty. Assigned")
                {
                }
                field("Qty. to Transfer"; "Qty. to Transfer")
                {
                }
                field("Transaction Date"; "Transaction Date")
                {
                }
                field("Transaction Time"; "Transaction Time")
                {
                }
                field(Resource; Resource)
                {
                    Visible = false;
                }
                field(Company; Company)
                {
                    Visible = false;
                }
            }
            group()
            {
                fixed()
                {
                    group(Assignable)
                    {
                        Caption = 'Assignable';
                        field(AssignableQty; AssignableQty)
                        {
                            Caption = 'Total (Qty.)';
                        }
                        field(AssgntAmount; AssgntAmount)
                        {
                            Caption = 'Total (Amount)';
                        }
                    }
                    group("To Assign")
                    {
                        Caption = 'To Assign';
                        field(TotalQtyToAssign; TotalQtyToAssign)
                        {
                            Caption = 'Total (Qty.)';
                        }
                        field(TotalAmountToAssign; TotalAmountToAssign)
                        {
                            Caption = 'Total (Amount)';
                        }
                    }
                    group("Rem. to Assign")
                    {
                        Caption = 'Rem. to Assign';
                        field(RemQtyToAssign; RemQtyToAssign)
                        {
                            Caption = 'Total (Qty.)';
                        }
                        field(RemAmountToAssign; RemAmountToAssign)
                        {
                            Caption = 'Total (Amount)';
                        }
                    }
                    group("To Transfer")
                    {
                        Caption = 'To Transfer';
                        field(QtyToPutIn; QtyToPutIn)
                        {
                            Caption = 'Total (Qty.)';
                        }
                    }
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action1101907050>")
            {
                Caption = 'Posting';
                action("<Action1101901001>")
                {
                    Caption = '&Assign';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        SIEAssignment.PostAssignment(FilterSIEAssgnt, 1)
                    end;
                }
                action("&Unassign")
                {
                    Caption = '&Unassign';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        SIEAssignment.PostUnAssignment(Rec, FALSE)
                    end;
                }
            }
            group(Functions)
            {
                Caption = 'Functions';
                action("<Action1101901003>")
                {
                    Caption = 'Suggest S&IE Assignment';
                    Promoted = true;
                    PromotedCategory = New;

                    trigger OnAction()
                    var
                        SIEAssignment: Codeunit "25006702";
                    begin
                        SIEAssignment.SuggestAssgnt(FilterSIEAssgnt);
                    end;
                }
                action("Add Unassigned Transaction")
                {
                    Caption = 'Add Unassigned Transaction';
                    Promoted = true;
                    PromotedCategory = New;

                    trigger OnAction()
                    var
                        SIEAssignment: Codeunit "25006702";
                    begin
                        SIEAssignment.AddUnassignedTran(FilterSIEAssgnt);
                    end;
                }
                separator()
                {
                }
                action(Transfer)
                {
                    Caption = 'Transfer';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        SIEAssignment: Codeunit "25006702";
                    begin
                        IF NOT CONFIRM(Text001, FALSE) THEN
                            EXIT;
                        SIEAssignment.TransferAll(FilterSIEAssgnt);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdateQtyAssgnt;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        AssignableQty := 0;
        TotalQtyToAssign := 0
    end;

    trigger OnOpenPage()
    begin
        FILTERGROUP(2);
        SETRANGE("Applies-to Type", FilterSIEAssgnt."Applies-to Type");
        SETRANGE(Corrected, FALSE);
        SETRANGE(Type, Type::Main);
        CASE "Appl. Type" OF
            "Appl. Type"::Service:
                BEGIN
                    SETRANGE("Applies-to Doc. Type", FilterSIEAssgnt."Applies-to Doc. Type");
                    SETRANGE("Applies-to Doc. No.", FilterSIEAssgnt."Applies-to Doc. No.");
                    IF FilterSIEAssgnt."Applies-to Doc. Line No." <> 0 THEN
                        SETRANGE("Applies-to Doc. Line No.", FilterSIEAssgnt."Applies-to Doc. Line No.")
                    ELSE
                        SETRANGE("Applies-to Doc. Line No.");
                END;
            "Appl. Type"::Sale:
                ;
        END;
        FILTERGROUP(0);
        SIEAssignment.DistributeTransfer(FilterSIEAssgnt);
    end;

    var
        Text001: Label 'Do you want to transfer all items?';
        Text002: Label 'Do you realy want to post put-on?';
        Text100: Label 'You don''t have rights to modify this field!';
        FilterSIEAssgnt: Record "25006706";
        SIELedgEntry: Record "25006703";
        ServHeader: Record "25006145";
        SalesHeader: Record "36";
        SIEAssignment: Codeunit "25006702";
        "Appl. Type": Option Service,Sale;
        AssignableQty: Decimal;
        TotalQtyToAssign: Decimal;
        RemQtyToAssign: Decimal;
        AssgntAmount: Decimal;
        TotalAmountToAssign: Decimal;
        RemAmountToAssign: Decimal;
        UnitCost: Decimal;
        QtyToPutIn: Decimal;
        DataCaption: Text[250];
        AssignableQtyTxt: Text[10];
        TotalQtyToAssignTxt: Text[10];
        RemQtyToAssignTxt: Text[10];

    [Scope('Internal')]
    procedure UpdateQtyAssgnt()
    var
        SIEAssgnt: Record "25006706";
        ServLine: Record "25006146";
    begin
        SIELedgEntry.GET("Entry No.");
        SIELedgEntry.CALCFIELDS("Qty. to Assign", "Qty. Assigned");
        AssignableQty := SIELedgEntry.Quantity - SIELedgEntry."Qty. Assigned";
        //AssignableQtyTxt := STRSUBSTNO('%1(%2)',AssignableQty,SIELedgEntry.Quantity);

        //AssgntAmount := AssignableQty * UnitCost;

        SIEAssgnt.RESET;
        SIEAssgnt.SETCURRENTKEY("Applies-to Type", "Applies-to Doc. Type", "Applies-to Doc. No.", "Applies-to Doc. Line No.");
        SIEAssgnt.SETRANGE("Applies-to Type", FilterSIEAssgnt."Applies-to Type");
        SIEAssgnt.SETRANGE("Applies-to Doc. Type", "Applies-to Doc. Type");
        SIEAssgnt.SETRANGE("Applies-to Doc. No.", "Applies-to Doc. No.");

        SIEAssgnt.SETRANGE(Type, Type::Main);

        IF "Appl. Type" = "Appl. Type"::Service THEN
            IF ServLine.GET("Applies-to Doc. Type", "Applies-to Doc. No.",
               "Applies-to Doc. Line No.") THEN BEGIN
                SIEAssgnt.SETRANGE("Applies-to Doc. Line No.", "Applies-to Doc. Line No.");
                SIEAssgnt.CALCSUMS("Qty. to Assign");
                QtyToPutIn := SIEAssgnt."Qty. to Assign";
                SIEAssgnt.SETRANGE(Type, Type::Detail);
                SIEAssgnt.CALCSUMS("Qty. Assigned Det.");
                //ServLine.CALCFIELDS("Transfered Quantity");
                //QtyToPutIn += (SIEAssgnt."Qty. Assigned Det." - ServLine."Transfered Quantity");
                SIEAssgnt.SETRANGE("Applies-to Doc. Line No.");
                SIEAssgnt.SETRANGE(Type, Type::Main);
            END ELSE
                QtyToPutIn := "Qty. to Assign";


        SIEAssgnt.SETRANGE("Entry No.", "Entry No.");

        SIEAssgnt.CALCSUMS("Qty. to Assign", "Amount to Assign");
        TotalQtyToAssign := SIEAssgnt."Qty. to Assign";
        //TotalQtyToAssignTxt := STRSUBSTNO('%1(%2)',TotalQtyToAssign,SIELedgEntry."Qty. to Assign");
        //TotalAmountToAssign := SIEAssgnt."Amount to Assign";

        RemQtyToAssign := AssignableQty - TotalQtyToAssign;
        //RemAmountToAssign := AssgntAmount - TotalAmountToAssign;
    end;

    local procedure UpdateQty()
    begin
    end;

    [Scope('Internal')]
    procedure Initialize(SIEAssgnt: Record "25006706")
    begin
        FilterSIEAssgnt := SIEAssgnt;
        DataCaption := SIEAssgnt."Applies-to Doc. No.";
        IF SIEAssgnt."Applies-to Doc. Line No." <> 0 THEN
            DataCaption := DataCaption + ' ' + SIEAssgnt.Description;
    end;
}


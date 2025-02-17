page 25006488 "Vehicle Req. Worksheet"
{
    AutoSplitKey = true;
    Caption = 'Vehicle Req. Worksheet';
    DataCaptionFields = "Journal Batch Name";
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = Table246;

    layout
    {
        area(content)
        {
            field(CurrentJnlBatchName; CurrentJnlBatchName)
            {
                Caption = 'Name';
                Lookup = true;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SAVERECORD;
                    ReqJnlManagement.LookupName(CurrentJnlBatchName, Rec);
                    CurrPage.UPDATE(FALSE);
                end;

                trigger OnValidate()
                begin
                    ReqJnlManagement.CheckName(CurrentJnlBatchName, Rec);
                    CurrentJnlBatchNameOnAfterVali;
                end;
            }
            repeater()
            {
                field(Type; Type)
                {
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ReqJnlManagement.GetDescriptionAndRcptName(Rec, Description2, BuyFromVendorName);
                    end;
                }
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Model Version No."; "Model Version No.")
                {
                }
                field("No."; "No.")
                {
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ReqJnlManagement.GetDescriptionAndRcptName(Rec, Description2, BuyFromVendorName);
                        ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Action Message"; "Action Message")
                {
                }
                field("Accept Action Message"; "Accept Action Message")
                {
                }
                field("Variant Code"; "Variant Code")
                {
                    Visible = false;
                }
                field(Description; Description)
                {
                }
                field("Description 2"; "Description 2")
                {
                    Visible = false;
                }
                field("Transfer-from Code"; "Transfer-from Code")
                {
                    Visible = false;
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Original Quantity"; "Original Quantity")
                {
                }
                field(Reserved; Reserved)
                {
                    Visible = false;
                }
                field(Quantity; Quantity)
                {
                }
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                }
                field(VIN; VIN)
                {
                }
                field("Vehicle Assembly ID"; "Vehicle Assembly ID")
                {
                    Visible = false;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                }
                field("Direct Unit Cost"; "Direct Unit Cost")
                {
                }
                field("Currency Code"; "Currency Code")
                {
                    AssistEdit = true;
                    Visible = false;

                    trigger OnAssistEdit()
                    begin
                        ChangeExchangeRate.SetParameter("Currency Code", "Currency Factor", WORKDATE);
                        IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN BEGIN
                            VALIDATE("Currency Factor", ChangeExchangeRate.GetParameter);
                        END;
                        CLEAR(ChangeExchangeRate);
                    end;
                }
                field("Line Discount %"; "Line Discount %")
                {
                    Visible = false;
                }
                field("Original Due Date"; "Original Due Date")
                {
                }
                field("Due Date"; "Due Date")
                {
                }
                field("Order Date"; "Order Date")
                {
                    Visible = false;
                }
                field("Vendor No."; "Vendor No.")
                {

                    trigger OnValidate()
                    begin
                        ReqJnlManagement.GetDescriptionAndRcptName(Rec, Description2, BuyFromVendorName);
                        ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Vendor Item No."; "Vendor Item No.")
                {
                }
                field("Order Address Code"; "Order Address Code")
                {
                    Visible = false;
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                    Visible = false;
                }
                field("Ship-to Code"; "Ship-to Code")
                {
                    Visible = false;
                }
                field("Prod. Order No."; "Prod. Order No.")
                {
                    Visible = false;
                }
                field("Requester ID"; "Requester ID")
                {
                    Visible = false;
                }
                field(Confirmed; Confirmed)
                {
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    Visible = false;
                }
                field(ShortcutDimCode[3];ShortcutDimCode[3])
                {
                    CaptionClass = '1,2,3';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(3,ShortcutDimCode[3]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(3,ShortcutDimCode[3]);
                    end;
                }
                field("Vehicle Accounting Cycle No.";"Vehicle Accounting Cycle No.")
                {
                }
                field(ShortcutDimCode[4];ShortcutDimCode[4])
                {
                    CaptionClass = '1,2,4';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(4,ShortcutDimCode[4]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(4,ShortcutDimCode[4]);
                    end;
                }
                field(ShortcutDimCode[5];ShortcutDimCode[5])
                {
                    CaptionClass = '1,2,5';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(5,ShortcutDimCode[5]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(5,ShortcutDimCode[5]);
                    end;
                }
                field(ShortcutDimCode[6];ShortcutDimCode[6])
                {
                    CaptionClass = '1,2,6';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(6,ShortcutDimCode[6]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(6,ShortcutDimCode[6]);
                    end;
                }
                field(ShortcutDimCode[7];ShortcutDimCode[7])
                {
                    CaptionClass = '1,2,7';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(7,ShortcutDimCode[7]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(7,ShortcutDimCode[7]);
                    end;
                }
                field(ShortcutDimCode[8];ShortcutDimCode[8])
                {
                    CaptionClass = '1,2,8';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(8,ShortcutDimCode[8]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(8,ShortcutDimCode[8]);
                    end;
                }
                field("Ref. Order No.";"Ref. Order No.")
                {
                    Visible = false;
                }
                field("Ref. Order Type";"Ref. Order Type")
                {
                    Visible = false;
                }
                field("Replenishment System";"Replenishment System")
                {
                }
                field("Ref. Line No.";"Ref. Line No.")
                {
                    Visible = false;
                }
                field("Planning Flexibility";"Planning Flexibility")
                {
                    Visible = false;
                }
                field("Purchasing Code";"Purchasing Code")
                {
                    Visible = false;
                }
            }
            group()
            {
                fixed()
                {
                    group(Description)
                    {
                        Caption = 'Description';
                        field(Description2;Description2)
                        {
                            Editable = false;
                        }
                    }
                    group("Buy-from Vendor Name")
                    {
                        Caption = 'Buy-from Vendor Name';
                        field(BuyFromVendorName;BuyFromVendorName)
                        {
                            Caption = 'Buy-from Vendor Name';
                            Editable = false;
                        }
                    }
                }
            }
        }
        area(factboxes)
        {
            part(;9090)
            {
                SubPageLink = No.=FIELD(No.);
                Visible = true;
            }
            systempart(;Links)
            {
                Visible = false;
            }
            systempart(;Notes)
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
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Codeunit 335;
                    ShortCutKey = 'Shift+F7';
                }
                action("<Action1101904006>")
                {
                    Caption = 'Vehicle Assembly';
                    Image = CheckList;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = false;

                    trigger OnAction()
                    begin
                        VehicleAssembly
                    end;
                }
                action("<Action1101904008>")
                {
                    Caption = 'Reservation Entries';
                    Image = ReservationLedger;

                    trigger OnAction()
                    begin
                        ShowVehReservationEntries(TRUE)
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                group("Drop Shipment")
                {
                    Caption = 'Drop Shipment';
                    Image = Delivery;
                    action("Get &Sales Orders")
                    {
                        Caption = 'Get &Sales Orders';
                        Ellipsis = true;
                        Image = "Order";

                        trigger OnAction()
                        begin
                            GetSalesOrder.SetReqWkshLine(Rec,0);
                            GetSalesOrder.RUNMODAL;
                            CLEAR(GetSalesOrder);
                        end;
                    }
                    action("Sales &Order")
                    {
                        Caption = 'Sales &Order';
                        Image = Document;

                        trigger OnAction()
                        begin
                            SalesHeader.SETRANGE("No.","Sales Order No.");
                            SalesOrder.SETTABLEVIEW(SalesHeader);
                            SalesOrder.EDITABLE := FALSE;
                            SalesOrder.RUN;
                        end;
                    }
                }
                group("Special Order")
                {
                    Caption = 'Special Order';
                    Image = SpecialOrder;
                    action("Get &Sales Orders")
                    {
                        Caption = 'Get &Sales Orders';
                        Ellipsis = true;
                        Image = "Order";

                        trigger OnAction()
                        begin
                            GetSalesOrder.SetReqWkshLine(Rec,1);
                            GetSalesOrder.RUNMODAL;
                            CLEAR(GetSalesOrder);
                        end;
                    }
                    action("Sales &Order")
                    {
                        Caption = 'Sales &Order';
                        Image = Document;

                        trigger OnAction()
                        begin
                            SalesHeader.SETRANGE("No.","Sales Order No.");
                            SalesOrder.SETTABLEVIEW(SalesHeader);
                            SalesOrder.EDITABLE := FALSE;
                            SalesOrder.RUN;
                        end;
                    }
                }
                action("Carry &Out Action Message")
                {
                    Caption = 'Carry &Out Action Message';
                    Ellipsis = true;
                    Image = CarryOutActionMessage;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        PerformAction: Report "493";
                    begin
                        PerformAction.SetReqWkshLine(Rec);
                        PerformAction.RUNMODAL;
                        PerformAction.GetReqWkshLine(Rec);
                        CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                        CurrPage.UPDATE(FALSE);
                    end;
                }
                action("&Reserve")
                {
                    Caption = '&Reserve';
                    Image = Reserve;

                    trigger OnAction()
                    begin
                        CurrPage.SAVERECORD;
                        ShowVehReservation;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ShowShortcutDimCode(ShortcutDimCode);
        OnAfterGetCurrRecord;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        "Accept Action Message" := FALSE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        ReqJnlManagement.SetUpNewLine(Rec,xRec);
        CLEAR(ShortcutDimCode);
        OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    var
        JnlSelected: Boolean;
    begin
        OpenedFromBatch := ("Journal Batch Name" <> '') AND ("Worksheet Template Name" = '');
        IF OpenedFromBatch THEN BEGIN
          CurrentJnlBatchName := "Journal Batch Name";
          ReqJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
          EXIT;
        END;
        ReqJnlManagement.TemplateSelection(PAGE::"Vehicle Req. Worksheet",FALSE,0,Rec,JnlSelected);
        IF NOT JnlSelected THEN
          ERROR('');
        CurrentJnlBatchName := "Journal Batch Name";
        ReqJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
    end;

    var
        SalesHeader: Record "36";
        GetSalesOrder: Report "698";
                           ReqJnlManagement: Codeunit "330";
                           SalesOrder: Page "42";
                           ChangeExchangeRate: Page "511";
                           CurrentJnlBatchName: Code[10];
                           Description2: Text[30];
                           BuyFromVendorName: Text[50];
                           ShortcutDimCode: array [8] of Code[20];
                           OpenedFromBatch: Boolean;

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SAVERECORD;
        ReqJnlManagement.SetName(CurrentJnlBatchName, Rec);
        CurrPage.UPDATE(FALSE);
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        ReqJnlManagement.GetDescriptionAndRcptName(Rec, Description2, BuyFromVendorName);
    end;
}


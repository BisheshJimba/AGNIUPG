page 25006468 "Transfer Order Subf. (Veh.)"
{
    // 30.04.2014 Elva Baltic P8 #F037 MMG7.00
    //   * Added fields:"Vehicle Status Code"
    // 
    // 27.04.2013 EDMS P8
    //   * Adjust to use veh. reservation

    AutoSplitKey = true;
    Caption = 'Vehicle Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = Table5741;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Model Version No."; "Model Version No.")
                {
                }
                field(VIN; VIN)
                {
                }
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                }
                field("Vehicle Accounting Cycle No."; "Vehicle Accounting Cycle No.")
                {
                }
                field("Sys. LC No."; "Sys. LC No.")
                {
                }
                field("Bank LC No."; "Bank LC No.")
                {
                    Editable = false;
                }
                field(Confirmed; Confirmed)
                {
                }
                field("Confirmed Date"; "Confirmed Date")
                {
                }
                field("Confirmed Time"; "Confirmed Time")
                {
                }
                field("Confirmed By"; "Confirmed By")
                {
                }
                field("Vehicle Registration No."; "Vehicle Registration No.")
                {
                }
                field("Item No."; "Item No.")
                {
                    Visible = false;
                }
                field("Variant Code"; "Variant Code")
                {
                    Visible = true;
                }
                field("Planning Flexibility"; "Planning Flexibility")
                {
                    Visible = false;
                }
                field(Description; Description)
                {
                }
                field("Transfer-from Bin Code"; "Transfer-from Bin Code")
                {
                    Visible = false;
                }
                field("Transfer-To Bin Code"; "Transfer-To Bin Code")
                {
                    Visible = false;
                }
                field(Quantity; Quantity)
                {
                    BlankZero = true;
                }
                field("Reserved Quantity Inbnd."; "Reserved Quantity Inbnd.")
                {
                    BlankZero = true;
                }
                field("Reserved Quantity Shipped"; "Reserved Quantity Shipped")
                {
                    BlankZero = true;
                }
                field("Reserved Quantity Outbnd."; "Reserved Quantity Outbnd.")
                {
                    BlankZero = true;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                }
                field("CC Memo No."; "CC Memo No.")
                {
                }
                field("PP No."; "PP No.")
                {
                    Caption = 'Pragyapan Patra No.';
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                    Visible = false;
                }
                field("Qty. to Ship"; "Qty. to Ship")
                {
                    BlankZero = true;
                }
                field("Quantity Shipped"; "Quantity Shipped")
                {
                    BlankZero = true;

                    trigger OnDrillDown()
                    var
                        TransShptLine: Record "5745";
                    begin
                        TESTFIELD("Document No.");
                        TESTFIELD("Item No.");
                        TransShptLine.SETCURRENTKEY("Transfer Order No.", "Item No.", "Shipment Date");
                        TransShptLine.SETRANGE("Transfer Order No.", "Document No.");
                        TransShptLine.SETRANGE("Item No.", "Item No.");
                        PAGE.RUNMODAL(0, TransShptLine);
                    end;
                }
                field("Qty. to Receive"; "Qty. to Receive")
                {
                    BlankZero = true;
                }
                field("Quantity Received"; "Quantity Received")
                {
                    BlankZero = true;

                    trigger OnDrillDown()
                    var
                        TransRcptLine: Record "5747";
                    begin
                        TESTFIELD("Document No.");
                        TESTFIELD("Item No.");
                        TransRcptLine.SETCURRENTKEY("Transfer Order No.", "Item No.", "Receipt Date");
                        TransRcptLine.SETRANGE("Transfer Order No.", "Document No.");
                        TransRcptLine.SETRANGE("Item No.", "Item No.");
                        PAGE.RUNMODAL(0, TransRcptLine);
                    end;
                }
                field("Shipment Date"; "Shipment Date")
                {
                }
                field("Receipt Date"; "Receipt Date")
                {
                }
                field("Shipping Agent Code"; "Shipping Agent Code")
                {
                    Visible = false;
                }
                field("Shipping Agent Service Code"; "Shipping Agent Service Code")
                {
                    Visible = false;
                }
                field("Shipping Time"; "Shipping Time")
                {
                    Visible = false;
                }
                field("Outbound Whse. Handling Time"; "Outbound Whse. Handling Time")
                {
                    Visible = false;
                }
                field("Inbound Whse. Handling Time"; "Inbound Whse. Handling Time")
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
                field(Kilometrage;Kilometrage)
                {
                    Visible = false;
                }
                field("Variable Field Run 2";"Variable Field Run 2")
                {
                    Visible = false;
                }
                field("Variable Field Run 3";"Variable Field Run 3")
                {
                    Visible = false;
                }
                field("Vehicle Status Code";"Vehicle Status Code")
                {
                    Visible = false;
                }
                field("Transfer-from Code";"Transfer-from Code")
                {
                    Visible = false;
                }
                field("Transfer-to Code";"Transfer-to Code")
                {
                    Visible = false;
                }
                field("Document Date";"Document Date")
                {
                    Editable = false;
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
                Image = "Action";
                action("&Reserve")
                {
                    Caption = '&Reserve';
                    Image = Reserve;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #5740. Unsupported part was commented. Please check it.
                        /*CurrPage.TransferLines.PAGE.*/
                        _ShowReservation;

                    end;
                }
                action("<Action1000000000>")
                {
                    Caption = 'Process Checklists';
                    RunObject = Page 25006010;
                                    RunPageLink = Vehicle Serial No.=FIELD(Vehicle Serial No.),
                                  Source ID=FIELD(Document No.);
                }
                action("<Action1905403704>")
                {
                    Caption = '&Order Promising';

                    trigger OnAction()
                    begin
                        VehicleOrderPromising
                    end;
                }
                action("<Action1000000004>")
                {
                    Caption = 'Confirmation';
                    Visible = false;

                    trigger OnAction()
                    var
                        ReqLine2: Record "246";
                    begin
                        CurrPage.SETSELECTIONFILTER(TransferLine);
                        IF TransferLine.FINDSET THEN REPEAT
                          ReqLine2.RESET;
                          ReqLine2.SETRANGE("Vehicle Serial No.",TransferLine."Vehicle Serial No.");
                          IF NOT ReqLine2.FINDFIRST THEN BEGIN
                            PurchLine.RESET;
                            PurchLine.SETRANGE("Vehicle Serial No.",TransferLine."Vehicle Serial No.");
                            IF NOT PurchLine.FINDFIRST THEN BEGIN
                               ERROR(VehicleAlreadyExists,TransferLine."Vehicle Serial No.");
                            END;
                          END;

                          TransferLine.Confirmed := TRUE;
                          TransferLine."Confirmed Date" := TODAY;
                          TransferLine."Confirmed Time" := TIME;
                          TransferLine."Confirmed By" := USERID;
                          TransferLine.MODIFY;
                        UNTIL TransferLine.NEXT =0;
                    end;
                }
                action("Remove Confirmation")
                {
                    Caption = 'Remove Confirmation';
                    Visible = false;

                    trigger OnAction()
                    begin
                        CurrPage.SETSELECTIONFILTER(TransferLine);
                        IF TransferLine.FINDSET THEN REPEAT
                          TransferLine.Confirmed := FALSE;
                          TransferLine."Confirmed Date" := 0D;
                          TransferLine."Confirmed Time" := 0T;
                          TransferLine."Confirmed By" := '';
                          TransferLine.MODIFY;
                        UNTIL TransferLine.NEXT =0;
                    end;
                }
            }
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                group("Item &Tracking Lines")
                {
                    Caption = 'Item &Tracking Lines';
                    Image = AllLines;
                    action(Shipment)
                    {
                        Caption = 'Shipment';
                        Image = Shipment;

                        trigger OnAction()
                        begin
                            OpenItemTrackingLines(0);
                        end;
                    }
                    action(Receipt)
                    {
                        Caption = 'Receipt';
                        Image = Receipt;

                        trigger OnAction()
                        begin
                            OpenItemTrackingLines(1);
                        end;
                    }
                }
                group("Item Availability by")
                {
                    Caption = 'Item Availability by';
                    Image = ItemAvailability;
                    action(Period)
                    {
                        Caption = 'Period';
                        Image = Period;

                        trigger OnAction()
                        begin
                            //This functionality was copied from page #5740. Unsupported part was commented. Please check it.
                            /*CurrPage.TransferLines.PAGE.*/
                            //_ItemAvailability(0); //30.10.2012 EDMS
                            ItemAvailFormsMgt.ShowItemAvailFromTransLine(Rec,ItemAvailFormsMgt.ByPeriod);

                        end;
                    }
                    action(Variant)
                    {
                        Caption = 'Variant';
                        Image = ItemVariant;

                        trigger OnAction()
                        begin
                            //This functionality was copied from page #5740. Unsupported part was commented. Please check it.
                            /*CurrPage.TransferLines.PAGE.*/
                            //_ItemAvailability(1);//30.10.2012
                            ItemAvailFormsMgt.ShowItemAvailFromTransLine(Rec,ItemAvailFormsMgt.ByVariant)

                        end;
                    }
                    action(Location)
                    {
                        Caption = 'Location';
                        Image = Warehouse;

                        trigger OnAction()
                        begin
                            //This functionality was copied from page #5740. Unsupported part was commented. Please check it.
                            /*CurrPage.TransferLines.PAGE.*/
                            //_ItemAvailability(2);//30.10.2012
                            ItemAvailFormsMgt.ShowItemAvailFromTransLine(Rec,ItemAvailFormsMgt.ByLocation);

                        end;
                    }
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #5740. Unsupported part was commented. Please check it.
                        /*CurrPage.TransferLines.PAGE.*/
                        _ShowDimensions;

                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnDeleteRecord(): Boolean
    var
        ReserveTransferLine: Codeunit "99000836";
    begin
        COMMIT;
        IF NOT ReserveTransferLine.DeleteLineConfirm(Rec) THEN
          EXIT(FALSE);
        ReserveTransferLine.DeleteLine(Rec);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        CLEAR(ShortcutDimCode);

        //EDMS >>
         "Document Profile" := "Document Profile"::"Vehicles Trade";
        //EDMS <<
    end;

    var
        ShortcutDimCode: array [8] of Code[20];
        ItemAvailFormsMgt: Codeunit "353";
        TransferLine: Record "5741";
        PurchLine: Record "39";
        VehicleAlreadyExists: Label 'The Vehicle with Serial No. %1 has not been order promised.';

    [Scope('Internal')]
    procedure _ShowDimensions()
    begin
        Rec.ShowDimensions;
    end;

    [Scope('Internal')]
    procedure ShowDimensions()
    begin
        Rec.ShowDimensions;
    end;

    [Scope('Internal')]
    procedure _ShowReservation()
    begin
        FIND;
        Rec.ShowVehReservation;  //27.04.2013 EDMS P8
    end;

    [Scope('Internal')]
    procedure ShowReservation()
    begin
        FIND;
        Rec.ShowReservation;
    end;

    [Scope('Internal')]
    procedure _OpenItemTrackingLines(Direction: Option Outbound,Inbound)
    begin
        OpenItemTrackingLines(Direction);
    end;

    [Scope('Internal')]
    procedure OpenItemTrackingLines(Direction: Option Outbound,Inbound)
    begin
        OpenItemTrackingLines(Direction);
    end;

    [Scope('Internal')]
    procedure UpdateForm(SetSaveRecord: Boolean)
    begin
        CurrPage.UPDATE(SetSaveRecord);
    end;

    [Scope('Internal')]
    procedure VehicleOrderPromising()
    var
        TransLIne: Record "5741";
    begin
        IF "Document Profile" <> "Document Profile"::"Vehicles Trade" THEN
         EXIT;

        TransLIne.RESET;
        //TransLIne.SETRANGE("Document Type",Rec."Document Type");
        TransLIne.SETRANGE("Document No.",Rec."Document No.");
        TransLIne.SETRANGE("Line No.",Rec."Line No.");
        TransLIne.FINDFIRST;
        PAGE.RUNMODAL(PAGE::"Vehicle Order Promising (TO)",TransLIne);
    end;
}


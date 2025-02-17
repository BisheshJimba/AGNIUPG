page 25006503 "Vehicle Reservation Entries"
{
    Caption = 'Vehicle Reservation Entries';
    DataCaptionExpression = TextCaption;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = Table25006392;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Make Code"; "Make Code")
                {
                    Editable = false;
                }
                field("Model Code"; "Model Code")
                {
                    Editable = false;
                }
                field("Model Version No."; "Model Version No.")
                {
                    Editable = false;
                }
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                    Editable = false;
                }
                field(VIN; VIN)
                {
                }
                field("Engine No."; "Engine No.")
                {
                }
                field("Location Code"; "Location Code")
                {
                    Editable = false;
                }
                field("Created By"; "Created By")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Changed By"; "Changed By")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Customer No."; "Customer No.")
                {
                }
                field("Customer Name"; "Customer Name")
                {
                }
                field(ReservEngineMgt.CreateForText(Rec);
                    ReservEngineMgt.CreateForText(Rec))
                {
                    Caption = 'Reserved For';
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupReservedFor;
                    end;
                }
                field(ReservEngineMgt.CreateFromText(Rec);
                    ReservEngineMgt.CreateFromText(Rec))
                {
                    Caption = 'Reserved From';
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupReservedFrom;
                    end;
                }
                field(Description; Description)
                {
                    Visible = false;
                }
                field(Quantity; Quantity)
                {
                    Visible = false;
                }
                field("Source Type"; "Source Type")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Source Subtype"; "Source Subtype")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Source ID"; "Source ID")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Booked Date"; "Booked Date")
                {
                }
                field("Source Batch Name"; "Source Batch Name")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Source Ref. No."; "Source Ref. No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Creation Date"; "Creation Date")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Positive; Positive)
                {
                    Editable = false;
                }
                field("Entry No."; "Entry No.")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Cancel Reservation")
                {
                    Caption = 'Cancel Reservation';
                    Image = Cancel;

                    trigger OnAction()
                    begin
                        CurrPage.SETSELECTIONFILTER(ReservEntry);
                        IF ReservEntry.FINDSET THEN
                            REPEAT
                                IF CONFIRM(
                                     Text003 +
                                     Text004 +
                                     Text005, FALSE, ReservEntry.Quantity,
                                     ReservEntry."Model Version No.", ReservEngineMgt.CreateForText(Rec),
                                     ReservEngineMgt.CreateFromText(Rec))
                                THEN BEGIN
                                    ReservEngineMgt.CloseReservEntry2(ReservEntry);
                                    COMMIT;
                                END;
                            UNTIL ReservEntry.NEXT = 0;
                    end;
                }
            }
        }
    }

    trigger OnModifyRecord(): Boolean
    begin
        ReservEngineMgt.ModifyReservEntry(xRec, Quantity, Description, TRUE);
        EXIT(FALSE);
    end;

    var
        Text003: Label 'Cancel reservation of %1 of item number %2,\';
        Text004: Label 'reserved for %3\';
        Text005: Label 'from %4?';
        SalesLine: Record "37";
        ReqLine: Record "246";
        PurchLine: Record "39";
        ItemJnlLine: Record "83";
        ItemLedgEntry: Record "32";
        TransLine: Record "5741";
        ReservEntry: Record "25006392";
        ReservEngineMgt: Codeunit "25006316";
        Customer: Record "18";

    [Scope('Internal')]
    procedure LookupReservedFor()
    var
        ReservEntry: Record "25006392";
    begin
        ReservEntry.GET("Entry No.", FALSE);
        LookupReserved(ReservEntry);
    end;

    [Scope('Internal')]
    procedure LookupReservedFrom()
    var
        ReservEntry: Record "25006392";
    begin
        ReservEntry.GET("Entry No.", TRUE);
        LookupReserved(ReservEntry);
    end;

    [Scope('Internal')]
    procedure LookupReserved(ReservEntry: Record "25006392")
    begin
        CASE ReservEntry."Source Type" OF
            DATABASE::"Sales Line":
                BEGIN
                    SalesLine.RESET;
                    SalesLine.SETRANGE("Document Type", ReservEntry."Source Subtype");
                    SalesLine.SETRANGE("Document No.", ReservEntry."Source ID");
                    SalesLine.SETRANGE("Line No.", ReservEntry."Source Ref. No.");
                    PAGE.RUNMODAL(PAGE::"Sales Lines", SalesLine);
                END;
            DATABASE::"Requisition Line":
                BEGIN
                    ReqLine.RESET;
                    ReqLine.SETRANGE("Worksheet Template Name", ReservEntry."Source ID");
                    ReqLine.SETRANGE("Journal Batch Name", ReservEntry."Source Batch Name");
                    ReqLine.SETRANGE("Line No.", ReservEntry."Source Ref. No.");
                    PAGE.RUNMODAL(PAGE::"Requisition Lines", ReqLine);
                END;
            DATABASE::"Purchase Line":
                BEGIN
                    PurchLine.RESET;
                    PurchLine.SETRANGE("Document Type", ReservEntry."Source Subtype");
                    PurchLine.SETRANGE("Document No.", ReservEntry."Source ID");
                    PurchLine.SETRANGE("Line No.", ReservEntry."Source Ref. No.");
                    PAGE.RUNMODAL(PAGE::"Purchase Lines", PurchLine);
                END;
            DATABASE::"Item Journal Line":
                BEGIN
                    ItemJnlLine.RESET;
                    ItemJnlLine.SETRANGE("Journal Template Name", ReservEntry."Source ID");
                    ItemJnlLine.SETRANGE("Journal Batch Name", ReservEntry."Source Batch Name");
                    ItemJnlLine.SETRANGE("Line No.", ReservEntry."Source Ref. No.");
                    ItemJnlLine.SETRANGE("Entry Type", ReservEntry."Source Subtype");
                    PAGE.RUNMODAL(PAGE::"Item Journal Lines", ItemJnlLine);
                END;
            DATABASE::"Item Ledger Entry":
                BEGIN
                    ItemLedgEntry.RESET;
                    ItemLedgEntry.SETRANGE("Entry No.", ReservEntry."Source Ref. No.");
                    PAGE.RUNMODAL(0, ItemLedgEntry);
                END;
            DATABASE::"Transfer Line":
                BEGIN
                    TransLine.RESET;
                    TransLine.SETRANGE("Document No.", ReservEntry."Source ID");
                    TransLine.SETRANGE("Line No.", ReservEntry."Source Ref. No.");
                    PAGE.RUNMODAL(0, TransLine);
                END;
        END;
    end;
}


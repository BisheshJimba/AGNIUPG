page 33020231 "Posted Vehicle Acc. Card"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = Table33020179;

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = false;
                field("No."; "No.")
                {

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit(xRec) THEN
                            CurrPage.UPDATE();
                    end;
                }
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {

                    trigger OnValidate()
                    begin
                        CALCFIELDS(VIN, "Make Code", "Model Code", "Model Version No.")
                    end;
                }
                field("Vendor Code"; "Vendor Code")
                {

                    trigger OnValidate()
                    begin
                        CALCFIELDS("Vendor Name");
                    end;
                }
                field("Vendor Name"; "Vendor Name")
                {
                }
                field("Customer Code"; "Customer Code")
                {
                }
                field("Customer Name"; "Customer Name")
                {
                }
                field(Description; Description)
                {
                }
                field("Reason Code"; "Reason Code")
                {
                }
                field("Responsibility Center"; "Responsibility Center")
                {
                }
                field("Document Date"; "Document Date")
                {
                }
                field("Assigned User ID"; "Assigned User ID")
                {
                }
                field(VIN; VIN)
                {
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
                field(Approved; Approved)
                {
                }
                field("Total Cost"; "Total Cost")
                {
                    Style = Standard;
                    StyleExpr = TRUE;
                }
            }
            group("Vendor Invoice Details")
            {
                Caption = 'Vendor Invoice Details';
                field("Vendor Invoice No."; "Vendor Invoice No.")
                {
                    Editable = AllowEdit;
                }
            }
            part("Accessories Line"; 33020232)
            {
                Editable = false;
                SubPageLink = Document No.=FIELD(No.);
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("<Action1000000004>")
            {
                Caption = 'Posting';
                action("<Action1000000023>")
                {
                    Caption = 'Re&open';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Ctrl+o';

                    trigger OnAction()
                    begin
                        ReOpenMemo(Rec);
                    end;
                }
                action("<Action75>")
                {
                    Caption = '&Create Purchase Order';
                    Ellipsis = true;
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    var
                        Text000: Label 'Do you want create the Purchase Order for Document %1?';
                        VehAccHeader: Record "33020179";
                    begin
                        IF CONFIRM(Text000, TRUE, "No.") THEN BEGIN
                            //SetRecSelectionFilter(VehAccHeader);
                            IF CreatePurchaseOrder(Rec) THEN
                                MESSAGE('Purchase Order Created successfully.');
                        END;
                    end;
                }
            }
            group(Print)
            {
                Caption = 'Print';
                action("Re-Print")
                {
                    Caption = 'Re-Print';

                    trigger OnAction()
                    begin
                        CurrPage.SETSELECTIONFILTER(VehAccHeader);
                        REPORT.RUNMODAL(33020176, FALSE, FALSE, VehAccHeader);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IF NOT "Purchase Order Created" THEN
            AllowEdit := TRUE
        ELSE
            AllowEdit := FALSE;
    end;

    trigger OnOpenPage()
    begin
        IF NOT "Purchase Order Created" THEN
            AllowEdit := TRUE
        ELSE
            AllowEdit := FALSE;
    end;

    var
        [InDataSet]
        AllowEdit: Boolean;
        VehAccHeader: Record "33020179";

    [Scope('Internal')]
    procedure SetRecSelectionFilter(var VehAccHeader: Record "33020179")
    begin
        CurrPage.SETSELECTIONFILTER(VehAccHeader);
    end;
}


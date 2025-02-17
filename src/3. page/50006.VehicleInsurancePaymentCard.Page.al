page 50006 "Vehicle Insurance Payment Card"
{
    PageType = Card;
    SourceTable = Table33020169;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit(xRec) THEN
                            CurrPage.UPDATE();
                    end;
                }
                field(Description; Description)
                {
                }
                field("Insurance Company Code"; "Insurance Company Code")
                {
                }
                field("Insurance Company Name"; "Insurance Company Name")
                {
                }
                field("ShortCut Dimension 1 Code"; "ShortCut Dimension 1 Code")
                {
                }
                field("ShortCut Dimension 2 Code"; "ShortCut Dimension 2 Code")
                {
                }
            }
            part(; 50007)
            {
                SubPageLink = No.=FIELD(No.);
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
            group("<Action1000000017>")
            {
                Caption = 'Post/Print';
                action("<Action1000000008>")
                {
                    Caption = 'P&ost';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';
                    Visible = ShowPost;

                    trigger OnAction()
                    var
                        InsHeader: Record "33020169";
                        Text000: Label 'Do you want to Post Insurance Payment Memo?';
                    begin
                        IF CONFIRM(Text000) THEN BEGIN
                            IF NOT Posted THEN BEGIN
                                UpdateVehicleInsurance(Rec);
                                COMMIT;
                            END
                            ELSE
                                ERROR(Text000);
                            CurrPage.SETSELECTIONFILTER(InsHeader);
                            REPORT.RUNMODAL(50044, TRUE, FALSE, InsHeader);
                        END;
                    end;
                }
                action("<Action1000000011>")
                {
                    Caption = '&Print';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        InsHeader: Record "33020169";
                    begin
                        CurrPage.SETSELECTIONFILTER(InsHeader);
                        REPORT.RUNMODAL(50044, TRUE, FALSE, InsHeader);
                    end;
                }
            }
            group("Purchase Order")
            {
                Caption = 'Purchase Order';
                Visible = ISPosted;
                action("<Action1000000012>")
                {
                    Caption = 'Create PO';
                    Image = MakeOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = ISPosted;

                    trigger OnAction()
                    begin
                        IF NOT CONFIRM(Text003) THEN
                            EXIT;
                        //message('123');
                        //sm to create purchase order
                        VehicleModuleSetup.GET;
                        ModuleCode := VehicleModuleSetup."Prepaid Insurance A/C";
                        //MESSAGE('%1',ModuleCode);
                        //sm to get default location of user
                        UserSetup.GET(USERID);
                        DefaultLocation := UserSetup."Default Location";
                        //DefaultRespCenter := UserSetup."Default Responsibility Center";
                        //SM 2-06-2013
                        DefaultAccCenter := UserSetup."Default Accountability Center";
                        //..................................................
                        InsPaymentMemoHeader.SETRANGE("No.", "No.");
                        IF InsPaymentMemoHeader.FINDFIRST THEN BEGIN
                            IF InsPaymentMemoHeader.OrderCreated = TRUE THEN BEGIN
                                //MESSAGE(text002);
                                ERROR(Text002, InsPaymentMemoHeader."No.");
                                EXIT;
                            END ELSE BEGIN
                                InsPaymentMemoLine.RESET;
                                InsPaymentMemoLine.SETRANGE("No.", "No.");
                                IF InsPaymentMemoLine.FINDFIRST THEN BEGIN
                                    REPEAT
                                        //to insert in purchase header

                                        CLEAR(PurchaseHeader);
                                        PurchaseHeader.INIT;
                                        IF InsPaymentMemoLine.Cancelled THEN
                                            PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::"Return Order"
                                        ELSE
                                            PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Order;

                                        //PurchaseHeader."No." := '';
                                        PurchaseHeader."Posting Date" := TODAY;
                                        PurchaseHeader.INSERT(TRUE);
                                        PurchaseHeader."Order Date" := TODAY;
                                        PurchaseHeader.VALIDATE("Buy-from Vendor No.", "Insurance Company Code");
                                        PurchaseHeader.VALIDATE("Shortcut Dimension 1 Code", "ShortCut Dimension 1 Code");
                                        PurchaseHeader.VALIDATE("Shortcut Dimension 2 Code", "ShortCut Dimension 2 Code");
                                        // PurchaseHeader.VALIDATE("Responsibility Center",VehicleModuleSetup."Reponsibility Center");
                                        PurchaseHeader.VALIDATE("Accountability Center", DefaultAccCenter);
                                        //PurchaseHeader.VALIDATE("Responsibility Center",DefaultRespCenter);
                                        PurchaseHeader.VALIDATE("Vendor Invoice No.", InsPaymentMemoLine."Bill No.");
                                        PurchaseHeader.VALIDATE("Location Code", DefaultLocation);
                                        PurchaseHeader.MODIFY(TRUE);

                                        //to insert in purchase line

                                        CLEAR(PurchaseLine);
                                        PurchaseLine.INIT;
                                        IF InsPaymentMemoLine.Cancelled THEN
                                            PurchaseLine."Document Type" := PurchaseLine."Document Type"::"Return Order"
                                        ELSE
                                            PurchaseLine."Document Type" := PurchaseLine."Document Type"::Order;

                                        PurchaseLine."Document No." := PurchaseHeader."No.";
                                        PurchaseLine."Line No." := 10000;

                                        PurchaseLine.INSERT(TRUE);

                                        PurchaseLine.VALIDATE(Type, PurchaseLine.Type::"G/L Account");

                                        PurchaseLine.VALIDATE("No.", VehicleModuleSetup."Prepaid Insurance A/C");
                                        PurchaseLine."VIN - COGS" := InsPaymentMemoLine."Chasis No.";
                                        PurchaseLine.VALIDATE(Quantity, 1);
                                        PurchaseLine.VALIDATE("Direct Unit Cost", InsPaymentMemoLine."Insurance Basic");
                                        PurchaseLine.MODIFY(TRUE);


                                    UNTIL InsPaymentMemoLine.NEXT = 0;

                                    InsPaymentMemoHeader.OrderCreated := TRUE;
                                    InsPaymentMemoHeader.MODIFY;
                                    MESSAGE(Text001, InsPaymentMemoHeader."No.");
                                    EXIT;
                                END;
                            END;

                        END;
                    end;
                }
            }
            group("<Action1000000016>")
            {
                Caption = 'Reverse';
                Visible = ISPosted;
                action("Undo Payment")
                {
                    Caption = 'Undo Payment';
                    Image = ReverseRegister;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = false;
                    Visible = ISPosted;

                    trigger OnAction()
                    var
                        VehicleInsurance: Record "25006033";
                        VehInsPaymentHeader: Record "33020169";
                        VehInsPaymentLine: Record "33020170";
                    begin
                        TESTFIELD(OrderCreated, FALSE);
                        VehInsPaymentLine.RESET;
                        VehInsPaymentLine.SETRANGE("No.", "No.");
                        IF VehInsPaymentLine.FINDSET THEN BEGIN
                            REPEAT
                                VehicleInsurance.RESET;
                                VehicleInsurance.SETCURRENTKEY("Insurance Policy No.");
                                VehicleInsurance.SETRANGE("Insurance Policy No.", VehInsPaymentLine."Insurance Policy No.");
                                VehicleInsurance.SETRANGE("Vehicle Serial No.", VehInsPaymentLine."Vehicle Serial No.");
                                IF VehicleInsurance.FINDFIRST THEN BEGIN
                                    VehicleInsurance."Payment Memo Generated" := FALSE;
                                    VehicleInsurance.MODIFY;
                                END;
                            UNTIL VehInsPaymentLine.NEXT = 0;
                            Posted := FALSE;
                            "Posting Date" := 0D;
                            MODIFY;
                            MESSAGE(Text004);
                        END;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        IF Posted = TRUE THEN BEGIN
            ShowPost := FALSE;
            ISPosted := TRUE;
        END ELSE BEGIN
            ShowPost := TRUE;
            ISPosted := FALSE;
        END;
    end;

    var
        Text000: Label 'Document has already been Posted.';
        VehicleModuleSetup: Record "33020011";
        PurchaseHeader: Record "38";
        PurchaseLine: Record "39";
        InsPaymentMemoLine: Record "33020170";
        Text001: Label 'Purchase Order of Ins. Payment Memo No. %1 created successfully!';
        ModuleCode: Code[20];
        [InDataSet]
        ISPosted: Boolean;
        InsPaymentMemoHeader: Record "33020169";
        Text002: Label 'Purchase Order for Ins. Payment Memo No. %1  is already created!';
        [InDataSet]
        ShowPost: Boolean;
        Text003: Label 'This job will create Purchase Order for all Insurance lines. Are you sure to process with?';
        UserSetup: Record "91";
        DefaultLocation: Code[10];
        DefaultRespCenter: Code[20];
        Text004: Label 'Document is reversed successfully.';
        DefaultAccCenter: Code[20];
}


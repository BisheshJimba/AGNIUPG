tableextension 50325 tableextension50325 extends "Responsibility Center"
{
    fields
    {
        modify(City)
        {
            TableRelation = IF (Country/Region Code=CONST()) "Post Code".City
                            ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Country/Region Code));
        }
        modify("Post Code")
        {
            TableRelation = IF (Country/Region Code=CONST()) "Post Code"
                            ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Country/Region Code));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Contract Gain/Loss Amount"(Field 5901)".

        field(50000;"Post Box No.";Code[20])
        {
        }
        field(50001;"Payment Method Code";Code[10])
        {
            TableRelation = "Payment Method";
        }
        field(50002;"Default Debit Note for Sales";Boolean)
        {
        }
        field(50003;"Skip Credit Limit Check";Boolean)
        {
            Description = '//Specially for Vehicle Finance';
        }
        field(33019810;"Advance Booking Batch";Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE (Journal Template Name=FIELD(Advance Booking Template));
        }
        field(33019811;"Advance Booking Template";Code[10])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(33019832;"Sales Quote Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019833;"Sales Blanket Order Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019834;"Sales Order Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019835;"Sales Return Order Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019836;"Sales Invoice Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019837;"Sales Posted Invoice Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019838;"Sales Credit Memo Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019839;"Sales Posted Credit Memo Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019840;"Sales Posted Shipment Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019841;"Purch. Quote Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019842;"Purch. Blanket Order Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019843;"Purch. Order Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019844;"Purch. Return Order Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019845;"Purch. Invoice Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019846;"Purch. Posted Invoice Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019847;"Purch. Credit Memo Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019848;"Purch. Posted Credit Memo Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019849;"Purch. Posted Receipt Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019850;"Serv. Order Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019851;"Serv. Invoice Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019852;"Serv. Posted Invoice Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019853;"Serv. Credit Memo Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019854;"Serv. Posted Credit Memo Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019855;"Trans. Order Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019856;"Posted Transfer Shpt. Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019857;"Posted Transfer Rcpt. Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019858;"Purch. Posted Prept. Inv. Nos.";Code[10])
        {
            Caption = 'Purch. Posted Prepmt. Inv. Nos.';
            TableRelation = "No. Series";
        }
        field(33019859;"Purch. Ptd. Prept. Cr. M. Nos.";Code[10])
        {
            Caption = 'Purch. Posted Prepmt. Cr. Memo Nos.';
            TableRelation = "No. Series";
        }
        field(33019860;"Purch. Ptd. Return Shpt. Nos.";Code[10])
        {
            Caption = 'Purch. Posted Return Shpt. Nos.';
            TableRelation = "No. Series";
        }
        field(33019861;"Sales Posted Prepmt. Inv. Nos.";Code[10])
        {
            Caption = 'Sales Posted Prepmt. Inv. Nos.';
            TableRelation = "No. Series";
        }
        field(33019862;"Sales Ptd. Prept. Cr. M. Nos.";Code[10])
        {
            Caption = 'Sales Posted Prepmt. Cr. Memo Nos.';
            TableRelation = "No. Series";
        }
        field(33019863;"Sales Ptd. Return Receipt Nos.";Code[10])
        {
            Caption = 'Sales Posted Return Receipt Nos.';
            TableRelation = "No. Series";
        }
        field(33019864;"Serv. Booking Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019865;"Serv. Posted Order Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019867;"Sales Posted Debit Note Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019868;"Serv. Quote Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019869;"Import Purch. Order Nos.";Code[10])
        {
        }
    }
}


table 33019845 "Gen. Journal Line Buffer"
{

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(4; "Account No."; Code[20])
        {
            TableRelation = IF (Account Type=CONST(G/L Account)) "G/L Account"
                            ELSE IF (Account Type=CONST(Customer)) Customer
                            ELSE IF (Account Type=CONST(Vendor)) Vendor
                            ELSE IF (Account Type=CONST(Bank Account)) "Bank Account"
                            ELSE IF (Account Type=CONST(Fixed Asset)) "Fixed Asset"
                            ELSE IF (Account Type=CONST(IC Partner)) "IC Partner";
        }
        field(5;"Posting Date";Date)
        {
        }
        field(6;"Document Type";Option)
        {
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(7;"Document No.";Code[20])
        {
        }
        field(8;Description;Text[50])
        {
        }
        field(9;Amount;Decimal)
        {
        }
        field(10;"Debit Amount";Decimal)
        {
        }
        field(11;"Credit Amount";Decimal)
        {
        }
        field(12;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
        }
        field(13;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
        }
        field(14;"Journal Batch Name";Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE (Journal Template Name=FIELD(Journal Template Name));
        }
        field(15;"Document Date";Date)
        {
        }
        field(16;"External Document No.";Code[20])
        {
        }
        field(17;Narration;Text[250])
        {
        }
        field(18;"Shortcut Dimension 3 Code";Code[20])
        {
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(3));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(19;"Shortcut Dimension 4 Code";Code[20])
        {
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(4));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(20;"Shortcut Dimension 5 Code";Code[20])
        {
            CaptionClass = '1,2,5';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(5));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(21;"Shortcut Dimension 6 Code";Code[20])
        {
            CaptionClass = '1,2,6';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(6));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(22;"Document Class";Option)
        {
            Caption = 'Document Class';
            OptionCaption = ' ,Customer,Vendor,Bank Account,Fixed Assets';
            OptionMembers = " ",Customer,Vendor,"Bank Account","Fixed Assets";
        }
        field(23;"Document Subclass";Code[20])
        {
            Caption = 'Document Subclass';
            TableRelation = IF (Document Class=CONST(Customer)) Customer
                            ELSE IF (Document Class=CONST(Vendor)) Vendor
                            ELSE IF (Document Class=CONST(Bank Account)) "Bank Account"
                            ELSE IF (Document Class=CONST(Fixed Assets)) "Fixed Asset";
        }
        field(480;"Dimension Set ID";Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
    }

    keys
    {
        key(Key1;"Journal Template Name","Journal Batch Name","Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        totalcount: Integer;
        ProgressWindow: Dialog;
        Text000: Label '#1###### of #2######## Records being Processed.';

    [Scope('Internal')]
    procedure CopyToGenJnl()
    var
        GenJnlLine: Record "81";
        GenJnlBuffer: Record "33019845";
        GenJnlTemplate: Record "80";
        GenJnlBatch: Record "232";
        GenJnlLine2: Record "81";
    begin
        ProgressWindow.OPEN(Text000);
        GenJnlBuffer.RESET;
        IF GenJnlBuffer.FINDSET THEN BEGIN
        ProgressWindow.UPDATE(2,GenJnlBuffer.COUNT);
        REPEAT
          CLEAR(GenJnlLine);
          GenJnlLine.RESET;
          GenJnlLine.INIT;
          GenJnlLine."Journal Template Name" := GenJnlBuffer."Journal Template Name";
          GenJnlLine."Journal Batch Name" := GenJnlBuffer."Journal Batch Name";
          GenJnlLine."Line No." := GenJnlBuffer."Line No.";

          GenJnlTemplate.GET(GenJnlBuffer."Journal Template Name");
          GenJnlBatch.GET(GenJnlBuffer."Journal Template Name",GenJnlBuffer."Journal Batch Name");

          GenJnlLine."Source Code" := GenJnlTemplate."Source Code";
          GenJnlLine."Reason Code" := GenJnlBatch."Reason Code";
          GenJnlLine."Posting No. Series" := GenJnlBatch."Posting No. Series";

          GenJnlLine.VALIDATE("Account Type",GenJnlBuffer."Account Type");
          GenJnlLine.VALIDATE("Account No.",GenJnlBuffer."Account No.");
          GenJnlLine.VALIDATE("Posting Date",GenJnlBuffer."Posting Date");
          GenJnlLine.VALIDATE("Document Type",GenJnlBuffer."Document Type");
          GenJnlLine.VALIDATE("Document No.",GenJnlBuffer."Document No.");
          GenJnlLine.Description := GenJnlBuffer.Description;
          GenJnlLine.VALIDATE(Amount,GenJnlBuffer.Amount);
          IF GenJnlBuffer."Debit Amount" <> 0 THEN
            GenJnlLine.VALIDATE("Debit Amount",GenJnlBuffer."Debit Amount");
          IF GenJnlBuffer."Credit Amount" <> 0 THEN
            GenJnlLine.VALIDATE("Credit Amount",GenJnlBuffer."Credit Amount");
          GenJnlLine.VALIDATE("Shortcut Dimension 1 Code",GenJnlBuffer."Shortcut Dimension 1 Code");
          GenJnlLine.VALIDATE("Shortcut Dimension 2 Code",GenJnlBuffer."Shortcut Dimension 2 Code");
          GenJnlLine.VALIDATE("Document Date",GenJnlBuffer."Document Date");
          GenJnlLine."External Document No." := GenJnlBuffer."External Document No.";
          GenJnlLine.Narration := GenJnlBuffer.Narration;
          GenJnlLine."Document Class" := GenJnlBuffer."Document Class";
          GenJnlLine."Document Subclass" := GenJnlBuffer."Document Subclass";
          GenJnlLine.INSERT;

          IF GenJnlBuffer."Shortcut Dimension 3 Code" <> '' THEN BEGIN
              GenJnlLine.ValidateShortcutDimCode(3,GenJnlBuffer."Shortcut Dimension 3 Code");
          END;
          totalcount += 1;
          ProgressWindow.UPDATE(1,totalcount);
        UNTIL GenJnlBuffer.NEXT = 0;
        GenJnlBuffer.RESET;
        IF GenJnlBuffer.FINDSET THEN BEGIN
          GenJnlBuffer.DELETEALL;
          MESSAGE('Journal Line Successfully Inserted.');
        END;
        END;
    end;
}


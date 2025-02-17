tableextension 50044 tableextension50044 extends "Incoming Document Attachment"
{
    procedure NewAttachmentFromHirepurchaseAppDocument(VehFinanceAppHeader: Record "Vehicle Finance App. Header")
    begin
        // NewAttachmentFromHirepurchaseDocument(
        //   VehFinanceAppHeader."Incoming Document Entry No.",//need to solve table error
        //   DATABASE::"Vehicle Finance App. Header",
        //   VehFinanceAppHeader."Application No.");
    end;

    procedure NewAttachmentFromHirepurchaseDocument(EntryNo: Integer; TableID: Integer; DocumentNo: Code[20])
    begin
        SETRANGE("Incoming Document Entry No.", EntryNo);
        SETRANGE("Document Table No. Filter", TableID);
        SETRANGE("Document No. Filter", DocumentNo);
        NewAttachment;
    end;
}


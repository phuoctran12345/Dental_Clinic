-- Thêm Foreign Key cho booked_by_user_id trong bảng Appointment
ALTER TABLE [dbo].[Appointment] 
ADD CONSTRAINT [FK_Appointment_BookedByUser] 
FOREIGN KEY ([booked_by_user_id]) REFERENCES [dbo].[users] ([user_id]);

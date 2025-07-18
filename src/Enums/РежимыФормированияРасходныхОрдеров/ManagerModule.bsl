#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает текст подсказки по режиму формирования расходных ордеров.
//
// Параметры:
//  РежимФормированияРасходныхОрдеров	 - ПеречислениеСсылка.РежимыФормированияРасходныхОрдеров - режим формирования
//  расходных ордеров.
// 
// Возвращаемое значение:
//  Строка - подсказка по режиму формирования расходных ордеров.
//
Функция ПодсказкаПоРежимуФормирования(РежимФормированияРасходныхОрдеров) Экспорт
	
	Если РежимФормированияРасходныхОрдеров = Перечисления.РежимыФормированияРасходныхОрдеров.Автоматически Тогда
		Возврат НСтр("ru = 'Ордера формируются и переформировываются автоматически после записи документов, влияющих на их формирование: заказов, накладных, заданий на перевозку.';
					|en = 'Goods issues are created and recreated automatically after the documents that affect their creation are saved, such as: orders, invoices, itineraries.'");
	ИначеЕсли РежимФормированияРасходныхОрдеров = Перечисления.РежимыФормированияРасходныхОрдеров.Кладовщиком Тогда
		Возврат НСтр("ru = 'Кладовщик вручную инициирует формирование и переформирование расходных ордеров по распоряжениям на отгрузку в рабочем месте ""Отгрузка"".';
					|en = 'Warehouse keeper manually starts creating and recreating goods issues under shipment references in the ""Shipment"" workplace.'");
	ИначеЕсли РежимФормированияРасходныхОрдеров = Перечисления.РежимыФормированияРасходныхОрдеров.Менеджером Тогда
		Возврат НСтр("ru = 'Менеджер инициирует формирование и переформирование расходных ордеров из списков распоряжений на отгрузку (т.е. из списков заказов и накладных). При использовании доставки ордера формирует менеджер по доставке в целом по заданию на перевозку.';
					|en = 'Employee initiates generation and regeneration of goods issues from shipment reference lists (i.e. from the lists of orders and invoices). If delivery is used, the delivery officer generates goods issues for the whole itinerary.'");
	Иначе
		Возврат НСтр("ru = 'Определяет инициатора формирования расходных ордеров.';
					|en = 'Determines an initiator of goods issue note generation.'");
	КонецЕсли;	
	
КонецФункции

#КонецОбласти

#КонецЕсли
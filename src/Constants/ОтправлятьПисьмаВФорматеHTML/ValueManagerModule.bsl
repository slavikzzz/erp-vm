///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Значение Тогда
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		Блокировка.Добавить("РегистрСведений.НастройкиУчетныхЗаписейЭлектроннойПочты");
		Блокировка.Заблокировать();
		
		// Переключение подписей всех учетных записей в обычный текст.
		НастройкиУчетныхЗаписей = РегистрыСведений.НастройкиУчетныхЗаписейЭлектроннойПочты.СоздатьНаборЗаписей();
		НастройкиУчетныхЗаписей.Прочитать();
		Для каждого Настройка Из НастройкиУчетныхЗаписей Цикл
			Настройка.ФорматПодписиДляНовыхСообщений = Перечисления.СпособыРедактированияЭлектронныхПисем.ОбычныйТекст;
			Настройка.ФорматПодписиПриОтветеПересылке = Перечисления.СпособыРедактированияЭлектронныхПисем.ОбычныйТекст;
		КонецЦикла;
		Если НастройкиУчетныхЗаписей.Модифицированность() Тогда
			НастройкиУчетныхЗаписей.Записать();
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли
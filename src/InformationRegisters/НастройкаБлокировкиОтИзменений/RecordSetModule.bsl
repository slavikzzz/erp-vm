// @strict-types

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДатаИзменения = ТекущаяДатаСеанса();
	Ответственный = Пользователи.ТекущийПользователь();
	
	Если ОбменДанными.Загрузка Тогда
		
		Для Каждого ТекСтр Из ЭтотОбъект Цикл

			ТекСтр.ЗаблокироватьПо = НачалоМесяца(ТекСтр.ЗаблокироватьПо);
			
			Если НЕ ЗначениеЗаполнено(ТекСтр.ДатаИзменения) Тогда
				ТекСтр.ДатаИзменения = ДатаИзменения;
			КонецЕсли;
			Если НЕ ЗначениеЗаполнено(ТекСтр.Ответственный) Тогда
				ТекСтр.Ответственный = Ответственный;
			КонецЕсли;
			Если ПустаяСтрока(ТекСтр.Комментарий) Тогда
				ТекСтр.Комментарий = НСтр("ru = 'Установлено при обмене данным';
											|en = 'Set upon data exchange'")
			КонецЕсли;
			
		КонецЦикла;
		
		Возврат;
		
	КонецЕсли;
	
	Для Каждого ТекСтр Из ЭтотОбъект Цикл
		
		ТекСтр.ЗаблокироватьПо = НачалоМесяца(ТекСтр.ЗаблокироватьПо);
		ТекСтр.ДатаИзменения = ДатаИзменения;
		ТекСтр.Ответственный = Ответственный;
		
		Если ПустаяСтрока(ТекСтр.Комментарий) Тогда
			ТекСтр.Комментарий = НСтр("ru = 'Способ установки блокировки не указан';
										|en = 'A method to set the lock is not specified'")
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

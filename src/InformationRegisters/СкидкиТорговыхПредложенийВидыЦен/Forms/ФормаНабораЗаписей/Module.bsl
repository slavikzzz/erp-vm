
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Параметры.Отбор.Свойство("ТорговоеПредложение", ТорговоеПредложение) 
		Или Не ЗначениеЗаполнено(ТорговоеПредложение) Тогда;
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ТорговыеПредложенияСлужебный.УстановитьУсловноеОформлениеФормыСкидок(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Для Каждого Запись Из НаборЗаписей Цикл
		
		ШаблонПоля = "НаборЗаписей[%1].%2";
		НомерСтроки = НаборЗаписей.Индекс(Запись);
		
		Если Запись.ВидыЦен.Пустая() Тогда
			ТекстСообщения = НСтр("ru = 'Не заполнена колонка ""Вид цены""';
									|en = 'The ""Price type"" column is not filled in'");
			Поле = СтрШаблон(ШаблонПоля, НомерСтроки, "ВидыЦен");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , Поле, , Отказ);
		КонецЕсли;
		
		Если Запись.Количество = 0 Тогда
			ТекстСообщения = НСтр("ru = 'Не заполнена колонка ""Количество""';
									|en = 'Column ""Quantity"" is not filled in'");
			Поле = СтрШаблон(ШаблонПоля, НомерСтроки, "Количество");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , Поле, , Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	УникальныеЗначенияКоличества = ОбщегоНазначения.ВыгрузитьКолонку(ТекущийОбъект, "Количество", Истина);
	Если УникальныеЗначенияКоличества.Количество() <> ТекущийОбъект.Количество() Тогда
		
		ТекстСообщения = НСтр("ru = 'Колонка ""количество от"" должна содержать уникальные значения.';
								|en = 'The ""minimum quantity"" column must contain unique values.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , , , Отказ);
		Возврат;
		
	КонецЕсли;
	
	Для Каждого Запись Из ТекущийОбъект Цикл
		
		Если Запись.ТорговоеПредложение.Пустая() Тогда
			
			Набор = РегистрыСведений.СкидкиТорговыхПредложенийВидыЦен.СоздатьНаборЗаписей();
			Набор.Отбор.ТорговоеПредложение.Установить(ТорговоеПредложение);
			Набор.Отбор.ВидыЦен.Установить(Запись.ВидыЦен);
			Набор.Прочитать();
			
			Если Набор.Количество() Тогда
				
				ШаблонСообщения = НСтр("ru = 'Вид цены ""%1"" уже используется в скидках торгового предложения';
										|en = 'The ""%1"" price type is already used in selling proposition discounts'");
				ТекстСообщения = СтрШаблон(ШаблонСообщения, Запись.ВидыЦен);
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , , , Отказ);
				Возврат;
				
			КонецЕсли;
			
			Запись.ТорговоеПредложение = ТорговоеПредложение;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	ОповеститьОбИзменении(ТорговоеПредложение);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНаборЗаписей

&НаКлиенте
Процедура НаборЗаписейПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	
	ТекущиеДанные = Элементы.НаборЗаписей.ТекущиеДанные;
	Если ТекущиеДанные.Количество = 1 Тогда
		
		ТекущиеДанные.Количество = 0;
		
		НомерСтроки = НаборЗаписей.Индекс(ТекущиеДанные);
		Поле = СтрШаблон("НаборЗаписей[%1].Количество", НомерСтроки);
		
		ТекстСообщения = НСтр("ru = 'Необходимо указать количество товара 
			|при котором будет предоставлена скидка больше одной единицы';
			|en = 'Specify the goods quantity
			|that grants the discount of more than one unit'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , Поле, , Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Варианты нарушений:
	// 0 - загрузка характеристики, когда номенклатура была загружена в режиме без характеристик
	
	Идентификаторы = Новый Массив;
	
	Параметры.Свойство("Идентификаторы",   Идентификаторы);
	Параметры.Свойство("ВариантНарушения", ВариантНарушения);

	Если ВариантНарушения = 0 Тогда

		Если Идентификаторы.Количество() = 1 Тогда
			
			СоответствияНоменклатуры = РаботаСНоменклатурой.
				НоменклатураПоИдентификаторам(Идентификаторы[0].ИдентификаторНоменклатуры);
			
			Если СоответствияНоменклатуры.Количество() = 0 Тогда
				ВызватьИсключение НСтр("ru = 'Не обнаружена номенклатура по идентификатору';
										|en = 'Products are not found by ID'");
			КонецЕсли;
			
			НоменклатураСсылка = СоответствияНоменклатуры[0].Номенклатура;
			
			СтрокаПояснения = НСтр("ru = 'Номенклатура <a href = ""НоменклатураСсылка"">%1</a> загружена без поддержки характеристик. 
				|Загрузка отдельных характеристик недоступна.';
				|en = 'Products <a href = ""НоменклатураСсылка"">%1</a> are imported without characteristics. 
				|You cannot import separate characteristics.'");
			
			СтрокаПояснения = СтрЗаменить(СтрокаПояснения, Символы.ПС, "");
			
		ИначеЕсли Идентификаторы.Количество() > 1 Тогда
			СтрокаПояснения = НСтр("ru = 'Выбраны характеристики, номенклатура которых загружена без поддержки характеристик.';
									|en = 'You selected characteristics which products are imported without characteristics.'");			
		КонецЕсли;
		
		СтрокаПояснения = СтрокаПояснения 
			+ Символы.ПС
			+ Символы.ПС
			+ НСтр("ru = 'Для возможности загрузки характеристик необходимо убедиться, что вид 
				|номенклатуры поддерживает характеристики, после чего привязать номенклатуру заново.';
				|en = 'To import characteristics, make sure that the 
				|product kind supports characteristics. After that, link products again.'");
				
		Если Идентификаторы.Количество() = 1 Тогда
			СтрокаПояснения = СтроковыеФункции.ФорматированнаяСтрока(СтрокаПояснения, НоменклатураСсылка);			
		КонецЕсли;
							
		Элементы.ПояснениеКФорме.Заголовок = СтрокаПояснения;
			
	КонецЕсли;
	
	КлючСохраненияПоложенияОкна = СтрШаблон("%1", Идентификаторы.Количество() = 1);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПояснениеКФормеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "НоменклатураСсылка" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ИмяФормыЭлемента = РаботаСНоменклатуройСлужебныйВызовСервера.ИмяФормыЭлементаНоменклатуры();
		
		ОткрытьФорму(ИмяФормыЭлемента, Новый Структура("Ключ", НоменклатураСсылка), ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

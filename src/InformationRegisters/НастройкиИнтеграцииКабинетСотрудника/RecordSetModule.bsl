#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий


Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтотОбъект.ДополнительныеСвойства.Свойство("ОбновитьНастройкиФункциональностьСервиса") Тогда
		РегистрыСведений.НастройкиСервисаКабинетСотрудника.УстановитьТребуетсяОбновитьНастройкиФункциональности(Истина);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	Если ЭтотОбъект.Количество() > 0 Тогда
		ИспользуетсяКадровыйЭДО = ЭтотОбъект[0].ИспользуетсяКадровыйЭДО;
		БизнесПроцессыЗаявокСотрудников.ПроверитьИИзменитьЗначениеНастроек(ИспользуетсяКадровыйЭДО);
		КадровыйЭДО.УстановитьЗначениеВедетсяУчетСогласийНаПрисоединениеККЭДО(ИспользуетсяКадровыйЭДО);
		Настройки = РегистрыСведений.ИспользуемаяФункциональностьСервисаКабинетСотрудника.Настройки();
		Если ИспользуетсяКадровыйЭДО Тогда
			Если Настройки.СкрытьРазделДокументы Или Настройки.ПолучениеДокументаСЭПНедоступно Тогда
				Настройки.СкрытьРазделДокументы = Ложь;
				Настройки.ПолучениеДокументаСЭПНедоступно = Ложь;
				РегистрыСведений.ИспользуемаяФункциональностьСервисаКабинетСотрудника.СохранитьНовыеНастройки(Настройки)
			КонецЕсли;
		Иначе
			Если Настройки.ДоступенОтказОтПодписания Тогда
				Настройки.ДоступенОтказОтПодписания = Ложь;
				РегистрыСведений.ИспользуемаяФункциональностьСервисаКабинетСотрудника.СохранитьНовыеНастройки(Настройки)
			КонецЕсли;
		КонецЕсли;
	Иначе
		КадровыйЭДО.УстановитьЗначениеВедетсяУчетСогласийНаПрисоединениеККЭДО(Ложь);
	КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);
		
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли